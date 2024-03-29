FROM golang:1.20-alpine as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN set -eux; \
    apk add --no-cache git; \
    git clone https://github.com/adnanh/webhook.git /src --branch 2.8.0; \
    cd /src; \
    go build -ldflags="-s -w" -o /usr/local/bin/webhook;

FROM alpine:3.17
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN webhook --version

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache curl
RUN apk add --no-cache git
RUN apk add --no-cache jq
RUN set -eux; \
    wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops; \
    chmod +x /usr/local/bin/sops; \
    sha256sum /usr/local/bin/sops | grep '^185348fd77fc160d5bdf3cd20ecbc796163504fd3df196d7cb29000773657b74 '; \
    sops --version

RUN apk add --no-cache gnupg
RUN apk add --no-cache openssh-client
WORKDIR /config
ENTRYPOINT [ "webhook" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]
