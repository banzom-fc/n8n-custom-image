FROM node:20-alpine

ARG N8N_VERSION

RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base ca-certificates && \
    npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
    apk del build-dependencies

# Tunneling support with cloudflared
RUN apk add --no-cache curl tar
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared

# Copy the startup script into the image
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Setting a custom user to not have n8n run as root    
RUN addgroup -S n8n && adduser -S n8n -G n8n
RUN mkdir -p /data && chown -R n8n:n8n /data
USER n8n

WORKDIR /data

# The main command to run our startup script
CMD ["/usr/local/bin/start.sh"]
