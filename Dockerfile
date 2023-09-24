FROM ghcr.io/identicum/alpine-jre17-tomcat9:latest

ADD src ./webapps/ROOT/

HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
