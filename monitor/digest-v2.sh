#!/bin/sh

ref="${1:-library/ubuntu:latest}"
repo="${ref%:*}"
tag="${ref##*:}"
acceptM="application/vnd.docker.distribution.manifest.v2+json"
acceptML="application/vnd.docker.distribution.manifest.list.v2+json"
token=$(/usr/bin/curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${repo}:pull" \
        | jq -r '.token')
/usr/bin/curl -H "Accept: ${acceptM}" \
     -H "Accept: ${acceptML}" \
     -H "Authorization: Bearer $token" \
     -I -s "https://registry-1.docker.io/v2/${repo}/manifests/${tag}"
