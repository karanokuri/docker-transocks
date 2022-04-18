# docker-transocks
docker image for transocks (https://github.com/cybozu-go/transocks)

## Example

```yaml
version: '3'

services:
  transocks:
    image: ghcr.io/karanokuri/docker-transocks:main
    init: true
    cap_add:
      - NET_ADMIN
    command: -loglevel info
    environment:
      TRANSOCKS_LISTEN: 0.0.0.0:1081
      TRANSOCKS_PROXY_URL: socks5://10.20.30.40:1080
    restart: always

  curl:
    image: curlimages/curl
    network_mode: 'service:transocks'
    command: ifconfig.io
```
