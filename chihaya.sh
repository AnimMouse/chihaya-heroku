#!/bin/sh
echo $CLOUDFLARE_TUNNEL_CONFIGURATION | base64 -d > cloudflare-tunnel-configuration.yaml
echo $CLOUDFLARE_TUNNEL_CREDENTIAL | base64 -d > cloudflare-tunnel-credential.json
./cloudflared tunnel --config cloudflare-tunnel-configuration.yaml run &
./chihaya --config chihaya-config.yaml