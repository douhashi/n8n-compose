FROM n8nio/n8n:latest

USER root

# Install ffmpeg, curl and iproute2
RUN apk add --no-cache ffmpeg curl iproute2

USER node