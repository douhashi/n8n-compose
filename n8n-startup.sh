#!/bin/sh
echo "Adding route to Tailscale network (100.64.0.0/10)…"
ip route add 100.64.0.0/10 via 10.51.0.10 2>/dev/null || true

echo "Switching to user 'node' and starting n8n…"
exec su-exec node:nogroup n8n

