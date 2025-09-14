#!/bin/sh

# The path where Docker mounts the secret file
SECRET_FILE="/run/secrets/cloudflared_token"

# Check if the secret file exists. If it does, start cloudflared.
if [ -f "$SECRET_FILE" ]; then
    echo "Starting Cloudflare Tunnel with provided token."
    # Run the tunnel in the background using the token from the secret file.
    /usr/local/bin/cloudflared tunnel --no-autoupdate run --token $(cat $SECRET_FILE) &
    # Log the PID of the cloudflared process
    echo "Cloudflared tunnel started with PID: $!"
else
    echo "No Cloudflare Tunnel token found, skipping tunnel setup."
fi

# Start n8n in the foreground.
# The container will exit if this process stops.
echo "Starting n8n..."
n8n