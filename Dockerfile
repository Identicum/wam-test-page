# Build runtime image
FROM identicum/centos-tomcat:latest

COPY ./src/* ./webapps/ROOT/

HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
