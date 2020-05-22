FROM tomcat:8-jdk11-openjdk-slim
LABEL maintainer="Gustavo J Gallardo <ggallard@identicum.com>"

RUN mkdir -p ./webapps/ROOT/
COPY ./src/* ./webapps/ROOT/

HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
