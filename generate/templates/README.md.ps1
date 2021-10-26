@"
# docker-webhook

[![github-actions](https://github.com/theohbrothers/docker-webhook/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-webhook/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-webhook?style=flat-square)](https://github.com/theohbrothers/docker-webhook/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-webhook/latest)](https://hub.docker.com/r/theohbrothers/docker-webhook)

Dockerized alpine with useful tools.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
$(
($VARIANTS | % {
    if ( $_['tag_as_latest'] ) {
@"
| ``:$( $_['tag'] )``, ``:latest`` | [View](variants/$( $_['tag'] ) ) |

"@
    }else {
@"
| ``:$( $_['tag'] )`` | [View](variants/$( $_['tag'] ) ) |

"@
    }
}) -join ''
)
"@
