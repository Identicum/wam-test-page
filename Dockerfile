FROM ghcr.io/identicum/centos-tomcat:latest

ADD src ./webapps/ROOT/

HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
