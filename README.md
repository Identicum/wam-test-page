# wam-test-page

Sample page to dump http headers and parameters received. 

![App screenshot](screenshot.png)

## Run as Docker container

```sh
docker run -d \
    --name wam-test-page \
    -p 8080:8080 \
    identicum/wam-test-page:latest
```

## Run in Application Server

Checkout the repo under a public folder in the Application Server.

For Tomcat:

```sh
    cd /usr/local/tomcat/webapps/ROOT
    git clone git@github.com:Identicum/wam-test-page.git
```

and start browsing <http://server:port/wam-test-page/src/index.jsp>

