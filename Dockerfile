FROM golang:bullseye as builder
RUN go install github.com/cybozu-go/transocks/cmd/transocks@v1.1.1

FROM debian:bullseye-slim
RUN apt-get update \
  && apt-get install --no-install-suggests --no-install-recommends -y iptables \
  && apt-get -y clean
COPY --from=builder /go/bin/transocks /usr/bin/
COPY entrypoint.sh /
ENTRYPOINT ["/bin/sh","/entrypoint.sh"]
