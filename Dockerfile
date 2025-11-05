FROM n8nio/n8n:latest

USER root

RUN apk add --no-cache ffmpeg curl iproute2 iptables su-exec yt-dlp

COPY n8n-startup.sh /usr/local/bin/n8n-startup.sh
RUN chmod +x /usr/local/bin/n8n-startup.sh

ENTRYPOINT ["/usr/local/bin/n8n-startup.sh"]

