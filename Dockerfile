FROM ghcr.io/identicum/alpine-jre17-tomcat9:latest

ADD src ./webapps/ROOT/
RUN apk add --no-cache curl
HEALTHCHECK --interval=10s --timeout=1s --start-period=4s --retries=5 CMD curl --fail http://localhost:8080/ || exit 1
