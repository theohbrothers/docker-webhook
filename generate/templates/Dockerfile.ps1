@"
FROM golang:1.20-alpine as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN set -eux; \
    apk add --no-cache git; \
    git clone https://github.com/adnanh/webhook.git /src --branch $( $VARIANT['_metadata']['package_version'] ); \
    cd /src; \
    go build -ldflags="-s -w" -o /usr/local/bin/webhook;

FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN webhook --version

RUN apk add --no-cache ca-certificates

"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {
        'curl' {
            @"
RUN apk add --no-cache curl

"@
        }

        'git' {
            @"
RUN apk add --no-cache git

"@
        }

        'jq' {
            @"
RUN apk add --no-cache jq

"@
        }

        { $_ -in @('libvirt-8', 'libvirt-7', 'libvirt-6') } {
    @"
RUN apk add --no-cache libvirt-client

"@
        }

        'sops' {
            if ( $VARIANT['_metadata']['distro'] -eq 'alpine' -and $VARIANT['_metadata']['distro_version'] -eq '3.6' ) {
                @"
# Fix wget not working in alpine:3.6. https://github.com/gliderlabs/docker-alpine/issues/423
RUN apk add --no-cache libressl

"@
            }
            @"
RUN set -eux; \
    wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops; \
    chmod +x /usr/local/bin/sops; \
    sha256sum /usr/local/bin/sops | grep '^185348fd77fc160d5bdf3cd20ecbc796163504fd3df196d7cb29000773657b74 '; \
    sops --version

RUN apk add --no-cache gnupg

"@
        }

        'ssh' {
            @"
RUN apk add --no-cache openssh-client

"@
        }

        'bare' {}

        default {
            throw "No such component: $component"
        }
    }
}

@"
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

WORKDIR /config
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]

"@
