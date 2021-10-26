@"
FROM golang:1.17.2-alpine3.14 as BUILD_IMAGE
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN apk add --no-cache git \
    && git clone https://github.com/adnanh/webhook.git /src --branch 2.8.0 \
    && cd /src \
    && OS="$( ($VARIANT['_metadata']['platforms'].split(',') | % { $_.split('/')[0] } | Select-Object -Unique ) -join ' ' )" \
       ARCH="$( ($VARIANT['_metadata']['platforms'].split(',') | % { $_.split('/')[1] } | Select-Object -Unique ) -join ' ' )" \
       go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] ) as final
COPY --from=BUILD_IMAGE /usr/local/bin/webhook /usr/local/bin/webhook
WORKDIR /config
ENTRYPOINT [ "webhook" ]
CMD [ "-verbose", "-hooks=/config/hooks.yml" ]

"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {

        'git' {
        @"
RUN apk add --no-cache git


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
RUN wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops && chmod +x /usr/local/bin/sops

RUN apk add --no-cache gnupg


"@
        }

        'bare' {}

        default {
            throw "No such component: $component"
        }
    }
}
