#!/bin/sh
echo "Starting n8n as node user..."
exec su-exec node:nogroup n8n

