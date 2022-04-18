#!/bin/sh
set -eu

if [ -z "${TRANSOCKS_PROXY_URL-}" ]; then
  echo "TRANSOCKS_PROXY_URL is not defined." >&2
  exit 1
fi

TRANSOCKS_LISTEN=${TRANSOCKS_LISTEN-localhost:1081}

iptables=iptables-legacy

$iptables -t nat -N TRANSOCKS
$iptables -t nat -I OUTPUT -p tcp -j TRANSOCKS
$iptables -t nat -A TRANSOCKS -d 0.0.0.0/8 -j RETURN
$iptables -t nat -A TRANSOCKS -d 10.0.0.0/8 -j RETURN
$iptables -t nat -A TRANSOCKS -d 127.0.0.0/8 -j RETURN
$iptables -t nat -A TRANSOCKS -d 169.254.0.0/16 -j RETURN
$iptables -t nat -A TRANSOCKS -d 172.16.0.0/12 -j RETURN
$iptables -t nat -A TRANSOCKS -d 192.168.0.0/16 -j RETURN
$iptables -t nat -A TRANSOCKS -d 224.0.0.0/4 -j RETURN
$iptables -t nat -A TRANSOCKS -d 240.0.0.0/4 -j RETURN
$iptables -t nat -A TRANSOCKS -p tcp -j REDIRECT --to-ports ${TRANSOCKS_LISTEN##*:}

cat << EOT > /etc/transocks.toml
listen = "${TRANSOCKS_LISTEN}"
proxy_url = "${TRANSOCKS_PROXY_URL}"
EOT

exec /usr/bin/transocks "$@"
