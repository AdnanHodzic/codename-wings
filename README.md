# codename-wings

## golang-server-webapp

Starts a (golang based) HTTP server on port 8080 with web app that has basic routing functionality, i.e:

* Displays which links are available: http://localhost
* Displays picture of Homer Simpson: http://localhost/homersimpson
* Displays current time in Amsterdam and in Covilha, Portugal: http://localhost/covilha

### Golang run example:

```
cd gofiles/; go run main.go
```

### Docker image build & publish using Makefile example:

```
make v=0.1
```

### Docker run example:

```
docker run -d -p 80:8080 docker.io/adnanhodzic/golang-server-webapp:0.1
```
