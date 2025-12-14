# N8N Docker Setup with Cloudflare Tunnel

A Docker Compose setup for n8n (workflow automation tool) with optional Cloudflare tunnel support using sidecar pattern.

## What This Does

- Runs n8n using official Docker image
- Optional Cloudflare tunnel as separate container (sidecar)
- All configuration via `.env` file
- Persistent data storage

## Quick Start

### Without Tunnel (Local Only)

1. **Copy environment file**:
   ```bash
   cp .env.example .env
   ```

2. **Start n8n**:
   ```bash
   docker compose up -d
   ```

3. **Access n8n**: http://localhost:5677

### With Cloudflare Tunnel

1. **Create Cloudflare tunnel**:
   - Go to https://one.dash.cloudflare.com/
   - Navigate to Networks → Tunnels → Create a tunnel
   - Copy your tunnel token
   - Configure Public Hostname:
     - Service Type: HTTP
     - URL: `n8n:5678`

2. **Configure environment**:
   ```bash
   cp .env.example .env
   nano .env
   ```
   
   Update:
   ```bash
   CLOUDFLARED_TOKEN=your-token-here
   COMPOSE_PROFILES=tunnel  # Uncomment this line
   ```

3. **Start with tunnel**:
   ```bash
   docker compose up -d
   ```

## Configuration

### Environment Variables (`.env` file)

**N8N Configuration:**
- `DOCKER_IMAGE` - n8n Docker image (default: docker.n8n.io/n8nio/n8n:latest)
- `CONTAINER_NAME` - Container name (default: n8n-container)
- `N8N_PORT` - Local port to access n8n (default: 5677)
- `N8N_HOST` - Host binding (default: 0.0.0.0)
- `N8N_PROTOCOL` - Protocol (default: http)
- `NODE_ENV` - Environment (default: production)
- `TZ` - Timezone (default: Asia/Kolkata)

**Cloudflared Configuration:**
- `CLOUDFLARED_IMAGE` - Cloudflared image (default: cloudflare/cloudflared:latest)
- `CLOUDFLARED_CONTAINER_NAME` - Container name (default: cloudflared-tunnel)
- `CLOUDFLARED_TOKEN` - Your Cloudflare tunnel token

**Docker Configuration:**
- `RESTART_POLICY` - Restart policy (default: unless-stopped)
- `COMPOSE_PROFILES` - Enable tunnel with `tunnel` value

## Architecture

- **n8n container**: Runs n8n on internal port 5678, exposed as 5677
- **cloudflared container**: Separate sidecar container (optional)
- **Bridge network**: Both containers communicate via `n8n_network`
- **Volume**: `n8n_data` for persistent storage

## Files Explained

- `docker-compose.yml` - Container orchestration with profiles
- `.env` - Your configuration (not in git)
- `.env.example` - Template for configuration
- `docker-entrypoint.sh` - Custom entrypoint for certificates

## Data Storage

Workflows and data are saved in Docker volume `n8n_data` at `/home/node/.n8n`, persisting across container restarts.

## Managing the Setup

```bash
# Start (without tunnel)
docker compose up -d

# Start (with tunnel)
docker compose up -d  # if COMPOSE_PROFILES=tunnel in .env

# Start (with tunnel, explicit)
docker compose --profile tunnel up -d

# Stop
docker compose down

# View logs
docker compose logs -f
docker compose logs -f n8n
docker compose logs -f cloudflared

# Restart
docker compose restart

# Update to latest
docker compose pull
docker compose up -d
```

## Security Notes

- Keep your `.env` file private (excluded from git)
- Cloudflare tunnel provides secure access without opening ports
- n8n runs as non-root user in official image
- Use strong passwords for n8n admin account
