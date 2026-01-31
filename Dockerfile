# Build stage to prepare yt-dlp and ffmpeg
FROM alpine:3.22 AS builder

RUN apk add --no-cache \
        ffmpeg \
        yt-dlp \
        python3

# Main stage - n8n with yt-dlp
FROM n8nio/n8n:latest

# Switch to root to copy binaries
USER root

# Copy yt-dlp and dependencies
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/yt-dlp
COPY --from=builder /usr/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /usr/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=builder /usr/bin/python3 /usr/local/bin/python3

# Copy Python and library dependencies
COPY --from=builder /usr/lib/python3* /usr/lib/
COPY --from=builder /usr/lib/libpython* /usr/lib/
COPY --from=builder /usr/lib/libav* /usr/lib/
COPY --from=builder /usr/lib/libsw* /usr/lib/
COPY --from=builder /usr/lib/libpostproc* /usr/lib/
COPY --from=builder /usr/lib/lib*.so* /usr/lib/

# Make binaries executable
RUN chmod +x /usr/local/bin/yt-dlp /usr/local/bin/ffmpeg /usr/local/bin/ffprobe /usr/local/bin/python3 || true

# Switch back to node user (n8n standard)
USER node

# Use the official entrypoint
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

