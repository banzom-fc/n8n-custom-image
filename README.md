# N8N Custom Docker Image

A custom Docker setup for n8n (workflow automation tool) with built-in Cloudflare tunnel support.

## What This Does

- Runs n8n in a Docker container
- Automatically sets up a secure tunnel through Cloudflare (optional)
- Includes image processing tools
- Uses a non-root user for security

## Quick Start

1. **Set your Cloudflare tunnel token** (optional):
   ```bash
   echo "your-cloudflare-token-here" > cloudflared_token.txt
   ```

2. **Start the container**:
   ```bash
   docker-compose up -d --build
   ```

3. **Access n8n**:
   - Local: http://localhost:5677
   - If using Cloudflare tunnel: through your tunnel URL

## Configuration

### Environment Variables

You can customize these in your `.env` file:

- `N8N_VERSION` - Which version of n8n to use (default: 1.110.1)
- `N8N_PORT` - Local port to access n8n (default: 5677)

### Cloudflare Tunnel (Optional)

If you want to access n8n from the internet securely:

1. Create a Cloudflare tunnel at https://dash.cloudflare.com
2. Copy your tunnel token
3. Put the token in `cloudflared_token.txt`
4. Start the container

If no token is provided, n8n will run without the tunnel (local access only).

## Files Explained

- `Dockerfile` - Instructions to build the custom n8n image
- `docker-compose.yml` - Easy way to run the container with all settings
- `start.sh` - Script that starts both the tunnel and n8n
- `build.sh` - Simple script to build the Docker image manually
- `cloudflared_token.txt` - Your Cloudflare tunnel token (keep this private)

## Building Manually

If you want to build the image yourself:

```bash
./build.sh
```

## Data Storage

Your n8n workflows and data are saved in a Docker volume called `n8n_data`, so they persist even if you restart the container.

## Security Notes

- The container runs as a non-root user
- Cloudflare tunnel provides secure access without opening ports
- Keep your `cloudflared_token.txt` file private
