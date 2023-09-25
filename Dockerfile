FROM ghcr.io/identicum/alpine-jre17-tomcat9:latest

ADD src ./webapps/ROOT/
RUN apk add --no-cache curl
HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
