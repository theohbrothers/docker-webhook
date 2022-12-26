FROM golang:1.17.2-alpine3.14 as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apk add --no-cache git \
    && git clone https://github.com/adnanh/webhook.git /src --branch 2.8.0 \
    && cd /src \
    && OS="linux" \
       ARCH="386 amd64 arm arm64 s390x" \
       go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM alpine:3.15
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache curl
RUN apk add --no-cache git
RUN apk add --no-cache jq
RUN wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops \
    && sha256sum /usr/local/bin/sops | grep 185348fd77fc160d5bdf3cd20ecbc796163504fd3df196d7cb29000773657b74

RUN apk add --no-cache gnupg
RUN apk add --no-cache openssh-client
WORKDIR /config
ENTRYPOINT [ "webhook" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]
