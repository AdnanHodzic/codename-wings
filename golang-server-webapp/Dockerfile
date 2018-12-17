FROM golang:alpine AS builder
# get all necessary prometheus libraries
RUN apk --no-cache add git \
    && go get -v github.com/prometheus/client_golang/prometheus/promhttp \
    && go get -v github.com/prometheus/client_golang/prometheus

WORKDIR /go/src/app
COPY gofiles/ .

RUN go build -o golang-server-webapp

FROM alpine:latest
WORKDIR /app
COPY --from=builder /go/src/app/ /app/

# setup timezone (necessary for /covilha)
RUN apk add --no-cache tzdata
ENV TZ Europe/Amsterdam

CMD ["./golang-server-webapp"]
