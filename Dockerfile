FROM n8nio/n8n:latest

USER root

# Install ffmpeg, curl and iproute2
RUN apk add --no-cache ffmpeg curl iproute2

# Copy and setup startup script
COPY n8n-startup.sh /n8n-startup.sh
RUN chmod +x /n8n-startup.sh

USER node

ENTRYPOINT ["/bin/sh", "/n8n-startup.sh"]