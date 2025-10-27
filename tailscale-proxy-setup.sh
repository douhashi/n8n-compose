#!/bin/bash

# Tailscale プロキシ経由でアクセスする設定例

# HTTPプロキシ経由でのcurlコマンド例
echo "# HTTPプロキシ経由でTailscale内のマシンにアクセス"
echo 'docker exec n8n curl --proxy http://ts-proxy:1080 http://your-tailscale-machine:8080/api'

# SOCKS5プロキシ経由でのcurlコマンド例
echo ""
echo "# SOCKS5プロキシ経由でTailscale内のマシンにアクセス"
echo 'docker exec n8n curl --proxy socks5://ts-proxy:1055 http://your-tailscale-machine:8080/api'

# n8n HTTP Requestノードでの設定方法
echo ""
echo "# n8n HTTP Requestノードでの設定:"
echo "1. HTTP Requestノードを追加"
echo "2. Options > Proxy を有効化"
echo "3. Proxy設定:"
echo "   - Protocol: http"
echo "   - Host: ts-proxy (または 10.51.0.10)"
echo "   - Port: 1080"
echo ""
echo "または SOCKS5を使用する場合:"
echo "   - Protocol: socks5"
echo "   - Host: ts-proxy (または 10.51.0.10)"
echo "   - Port: 1055"