# wam-test-page

Sample page to dump HTTP headers and received parameters. 

![App screenshot](screenshot.png)

## Run as Docker container

```sh
docker run -d \
    --name wam-test-page \
    -p 8080:8080 \
    ghcn.io/identicum/wam-test-page:latest
```

## Test

Navigate http://localhost:8080 or make the following curl call to get a JSON response:

```sh
curl -H "Accept: application/json" http://localhost:8080
```