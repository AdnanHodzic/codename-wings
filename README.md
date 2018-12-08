# codename-wings

## golang-server-webapp

Starts a (golang based) HTTP server on port 8080 with web app that has basic routing functionality, i.e:

* Displays which links are available: http://wings.hodzic.org
* Displays picture of Homer Simpson: http://wings.hodzic.org/homersimpson
* Displays current time in Amsterdam and in Covilha, Portugal: http://wings.hodzic.org/covilha

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
