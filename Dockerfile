FROM ghcr.io/identicum/python-flask:latest

COPY ./app/ /app

# sherpa's Logger writes to a file, not stdout; symlink it like the base image
# does for /tmp/python-flask.log so `docker logs` shows our log lines.
RUN ln -sf /dev/stdout /tmp/wam-test-page.log

ENV LOG_LEVEL=INFO
