# wam-test-page

Sample page to dump HTTP headers and received parameters. 

![App screenshot](screenshot.png)

## Run as Docker container

```sh
docker compose up -d
```

## Test

Navigate http://localhost:8080 or make the following curl call to get a JSON response:

```sh
curl -H "Accept: application/json" http://localhost:8080
```