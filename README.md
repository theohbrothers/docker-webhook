# docker-webhook

[![github-actions](https://github.com/theohbrothers/docker-webhook/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-webhook/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-webhook?style=flat-square)](https://github.com/theohbrothers/docker-webhook/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-webhook/latest)](https://hub.docker.com/r/theohbrothers/docker-webhook)

Dockerized [`webhook`](https://github.com/adnanh/webhook) with useful tools.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:2.8.0-alpine-3.12`, `:latest` | [View](variants/2.8.0-alpine-3.12 ) |
| `:2.8.0-sops-alpine-3.12` | [View](variants/2.8.0-sops-alpine-3.12 ) |
| `:2.7.0-alpine-3.12` | [View](variants/2.7.0-alpine-3.12 ) |
| `:2.7.0-sops-alpine-3.12` | [View](variants/2.7.0-sops-alpine-3.12 ) |


## Usage

```sh
# Create hooks.yml, see: https://github.com/adnanh/webhook#configuration
cat - > hooks.yml <<'EOF'
- id: hello-world
  execute-command: echo
EOF

# Start container
docker run -it -p 9000:9000 -v $(pwd)/hooks.yml:/config/hooks.yml:ro theohbrothers/docker-webhook

# Run the webhook
wget -qO- "http://$HOSTNAME:9000/hooks/hello-world"
```
