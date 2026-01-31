# Build stage to install additional packages
FROM alpine:3.22 AS builder

RUN apk add --no-cache ffmpeg curl iproute2 iptables su-exec yt-dlp

# Prepare startup script
COPY n8n-startup.sh /tmp/n8n-startup.sh
RUN chmod +x /tmp/n8n-startup.sh

# Final stage
FROM n8nio/n8n:latest

USER root

# Copy installed packages from builder
COPY --from=builder /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=builder /usr/bin/ffprobe /usr/bin/ffprobe
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /sbin/ip /sbin/ip
COPY --from=builder /usr/sbin/iptables /usr/sbin/iptables
COPY --from=builder /sbin/su-exec /sbin/su-exec
COPY --from=builder /usr/bin/yt-dlp /usr/bin/yt-dlp

# Copy dependencies
COPY --from=builder /usr/lib/ /usr/lib/
COPY --from=builder /lib/ /lib/

# Copy startup script with execute permissions
COPY --from=builder /tmp/n8n-startup.sh /usr/local/bin/n8n-startup.sh

ENTRYPOINT ["/usr/local/bin/n8n-startup.sh"]

