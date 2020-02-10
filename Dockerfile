FROM golang:1.13-alpine AS build

ENV CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64 \
  GO111MODULE=on

RUN apk add -U make git

WORKDIR /go/src/github.com/99designs/aws-vault

RUN git clone --branch v5.2.0 https://www.github.com/99designs/aws-vault.git . \
  && go build -a -tags netgo -ldflags '-w' -o /bin/aws-vault

FROM alpine:3.10

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=build /bin/aws-vault /aws-vault

ENTRYPOINT ["/aws-vault"]
