FROM golang:alpine AS builder
RUN apk --no-cache add git \
    && go get -v github.com/prometheus/client_golang/prometheus/promhttp

WORKDIR /go/src/app
COPY gofiles/ .

RUN go build -o golang-server-webapp

FROM alpine:latest
WORKDIR /app
COPY --from=builder /go/src/app/ /app/

RUN apk add --no-cache tzdata
ENV TZ Europe/Amsterdam

CMD ["./golang-server-webapp"]
