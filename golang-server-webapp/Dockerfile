FROM golang:alpine AS builder

WORKDIR /go/src/app
COPY gofiles/ .

RUN go build -o golang-server-webapp

FROM alpine:latest
WORKDIR /app
COPY --from=builder /go/src/app/ /app/

CMD ["./golang-server-webapp"]
