FROM golang:1.17.2-alpine3.14 as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apk add --no-cache git \
    && git clone https://github.com/adnanh/webhook.git /src --branch 2.8.0 \
    && cd /src \
    && go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM alpine:3.12
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN apk add --no-cache ca-certificates
WORKDIR /config
ENTRYPOINT [ "webhook" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]
