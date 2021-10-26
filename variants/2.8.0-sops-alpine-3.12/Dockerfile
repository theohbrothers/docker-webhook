FROM golang:1.17.2-alpine3.14 as BUILD_IMAGE
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apk add --no-cache git \
    && git clone https://github.com/adnanh/webhook.git /src --branch 2.8.0 \
    && cd /src \
    && OS="linux" \
       ARCH="386 amd64 arm arm64 s390x" \
       go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM alpine:3.12 as final
COPY --from=BUILD_IMAGE /usr/local/bin/webhook /usr/local/bin/webhook
WORKDIR /config
ENTRYPOINT [ "webhook" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]
RUN wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops && chmod +x /usr/local/bin/sops

RUN apk add --no-cache gnupg

