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

# Copy Python to correct location (matching yt-dlp shebang)
COPY --from=builder /usr/bin/python3 /usr/bin/python3

# Copy yt-dlp and ffmpeg
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/yt-dlp
COPY --from=builder /usr/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /usr/bin/ffprobe /usr/local/bin/ffprobe

# Copy Python libraries and dependencies
COPY --from=builder /usr/lib/python3.12 /usr/lib/python3.12
COPY --from=builder /usr/lib/libpython3.12.so* /usr/lib/
COPY --from=builder /usr/lib/libffi.so* /usr/lib/
COPY --from=builder /usr/lib/libexpat.so* /usr/lib/
COPY --from=builder /usr/lib/libbz2.so* /usr/lib/
COPY --from=builder /usr/lib/libmpdec.so* /usr/lib/
COPY --from=builder /usr/lib/libreadline.so* /usr/lib/
COPY --from=builder /usr/lib/libsqlite3.so* /usr/lib/
COPY --from=builder /usr/lib/libncursesw.so* /usr/lib/

# Copy ffmpeg dependencies
COPY --from=builder /usr/lib/libav* /usr/lib/
COPY --from=builder /usr/lib/libsw* /usr/lib/
COPY --from=builder /usr/lib/libpostproc* /usr/lib/
COPY --from=builder /usr/lib/lib*.so* /usr/lib/

# Install openssh-client and coder CLI (used by n8n Execute Command node to send keystrokes to Coder workspaces)
RUN apk add --no-cache openssh-client curl ca-certificates && \
    curl -fsSL https://coder.com/install.sh | sh -s -- --method=standalone --prefix=/usr/local && \
    coder version

# Switch back to node user (n8n standard)
USER node

# Use the official entrypoint
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

