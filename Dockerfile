FROM identicum/centos-tomcat:latest
LABEL maintainer="Gustavo J Gallardo <ggallard@identicum.com>"

ADD src ./webapps/ROOT/

HEALTHCHECK --timeout=5s CMD curl --fail http://localhost:8080/ || exit 1
