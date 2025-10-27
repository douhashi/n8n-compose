#!/bin/sh
# n8n起動スクリプト
# Tailscaleネットワークへのルートを追加してからn8nを起動

echo "Adding route to Tailscale network (100.64.0.0/10)..."
ip route add 100.64.0.0/10 via 10.51.0.10 2>/dev/null || true

echo "Starting n8n..."
exec n8n