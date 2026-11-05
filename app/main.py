import base64
import binascii
import json
import os
from datetime import datetime, timezone

from flask import Flask, jsonify, render_template, request
from sherpa.utils.basics import Logger

# Static files live under a prefix nobody is likely to proxy, so that /static/... can be inspected like any other path.
app = Flask(__name__, static_url_path="/_wtp/static")
app.config["MAX_CONTENT_LENGTH"] = 10 * 1024 * 1024

log_level = os.environ.get("LOG_LEVEL", "")
logger = Logger("wam-test-page", log_level=log_level, log_path="/tmp/wam-test-page.log", stdout=False)
logger.info("Logger initialized with level: {}.", log_level)

BODY_DISPLAY_LIMIT = 64 * 1024
ALL_METHODS = ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
JWT_TIME_CLAIMS = ("exp", "iat", "nbf", "auth_time")
SERVER_VARIABLES = (
	"REQUEST_METHOD",
	"REQUEST_URI",
	"SCRIPT_NAME",
	"PATH_INFO",
	"QUERY_STRING",
	"SERVER_NAME",
	"SERVER_PORT",
	"SERVER_PROTOCOL",
	"REMOTE_ADDR",
	"REMOTE_PORT",
	"REMOTE_USER",
	"AUTH_TYPE",
	"CONTENT_TYPE",
	"CONTENT_LENGTH",
	"wsgi.url_scheme",
	"SERVER_SOFTWARE",
)


def multi_dict(md):
	"""Flatten a MultiDict: a single value stays a string, repeated keys become a list."""
	result = {}
	for key in sorted(md.keys(), key=str.lower):
		values = md.getlist(key)
		result[key] = values[0] if len(values) == 1 else values
	return result


def b64url_decode(segment):
	return base64.urlsafe_b64decode(segment + "=" * (-len(segment) % 4))


def decode_jwt(value):
	"""Decode a JWT's header and payload without verifying it. Returns None if value isn't a JWT."""
	token = value.strip()
	if token.lower().startswith("bearer "):
		token = token[7:].strip()
	parts = token.split(".")
	if len(parts) != 3:
		return None
	try:
		header = json.loads(b64url_decode(parts[0]))
		payload = json.loads(b64url_decode(parts[1]))
	except (ValueError, binascii.Error):
		return None
	if not isinstance(header, dict) or "alg" not in header or not isinstance(payload, dict):
		return None
	times = {}
	for claim in JWT_TIME_CLAIMS:
		if isinstance(payload.get(claim), (int, float)):
			times[claim] = datetime.fromtimestamp(payload[claim], tz=timezone.utc).isoformat()
	return {"header": header, "payload": payload, "times": times}


def parse_authorization(value):
	if value is None:
		return None
	scheme, _, credentials = value.strip().partition(" ")
	details = {"scheme": scheme}
	if scheme.lower() == "basic":
		try:
			decoded = base64.b64decode(credentials.strip(), validate=True).decode("utf-8", errors="replace")
			username, _, password = decoded.partition(":")
			details.update({"username": username, "password": password})
		except (ValueError, binascii.Error):
			details["error"] = "Credentials are not valid base64"
	elif scheme.lower() == "bearer":
		jwt = decode_jwt(credentials)
		if jwt:
			details["jwt"] = jwt
	return details


def read_body():
	# Read the raw body before form parsing; Werkzeug parses request.form from the cached copy.
	raw = request.get_data(cache=True)
	if not raw or request.form or request.files:
		return None
	text = raw[:BODY_DISPLAY_LIMIT].decode("utf-8", errors="replace")
	body = {"length": len(raw), "truncated": len(raw) > BODY_DISPLAY_LIMIT, "text": text}
	if request.is_json:
		try:
			body["json"] = json.loads(raw)
		except ValueError:
			pass
	return body


def collect():
	body = read_body()
	headers = multi_dict(request.headers)
	jwt_headers = {}
	for name, value in headers.items():
		if name.lower() != "authorization" and isinstance(value, str):
			jwt = decode_jwt(value)
			if jwt:
				jwt_headers[name] = jwt
	authorization = request.headers.get("Authorization")
	return {
		"request": {
			"method": request.method,
			"url": request.url,
			"path": request.path,
			"scheme": request.scheme,
			"host": request.host,
			"remote_addr": request.remote_addr,
		},
		"http_headers": headers,
		"get_parameters": multi_dict(request.args),
		"post_parameters": multi_dict(request.form),
		"files": {name: [f.filename for f in request.files.getlist(name)] for name in request.files},
		"cookies": multi_dict(request.cookies),
		"body": body,
		"authorization_header": authorization,
		"authorization_details": parse_authorization(authorization),
		"jwt_headers": jwt_headers,
		"other_parameters": {name: request.environ.get(name) for name in SERVER_VARIABLES},
	}


def wants_json():
	# Browsers ask for text/html explicitly; "*/*" (curl's default) ties and falls back to HTML, listed first.
	return request.accept_mimetypes.best_match(["text/html", "application/json"]) == "application/json"


@app.route("/health", methods=["GET"])
def health():
	logger.trace("Health endpoint called.")
	return "OK"


@app.route("/", defaults={"path": ""}, methods=ALL_METHODS)
@app.route("/<path:path>", methods=ALL_METHODS)
def dump(path):
	data = collect()
	logger.debug("{} {} from {}", request.method, request.full_path, request.remote_addr)
	logger.trace("Request data: {}", json.dumps(data))
	if wants_json():
		return jsonify(data)
	return render_template("index.html", data=data)


if __name__ == "__main__":
	app.run()
