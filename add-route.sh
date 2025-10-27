#!/bin/sh
# Tailscale ネットワーク (100.64.0.0/10) へのルートを追加
# これにより、n8nコンテナがTailscale内のマシンにアクセスできるようになる

echo "Adding route to Tailscale network..."
ip route add 100.64.0.0/10 via 10.51.0.10 2>/dev/null || true
echo "Route added successfully"