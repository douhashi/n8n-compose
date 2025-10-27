#!/bin/sh
set -e

echo "Starting Tailscale daemon..."
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/tmp/tailscaled.sock &
TAILSCALED_PID=$!

# Wait for tailscaled to be ready
sleep 5

echo "Authenticating with Tailscale..."
tailscale --socket=/tmp/tailscaled.sock up \
  --authkey="${TS_AUTHKEY}" \
  --accept-routes \
  --hostname="n8n-compose-ts"

echo "Starting SOCKS5 proxy on port 1055..."
tailscale --socket=/tmp/tailscaled.sock serve socks5 --set-proxy-to=127.0.0.1:1055 &

echo "Starting HTTP proxy on port 1080..."
tailscale --socket=/tmp/tailscaled.sock serve proxy 1080 &

# Keep the container running
wait $TAILSCALED_PID