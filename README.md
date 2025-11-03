# server-tailscale

Docker image for running **Tailscale** with **socat** port forwarding.  
Useful for connecting Docker services to your Tailnet and redirecting ports securely.

---

## 🚀 Features
- Based on **Debian Bullseye Slim**
- Installs the official **Tailscale** package
- Includes **socat** for flexible TCP/UDP port forwarding
- Supports automatic startup with environment variables

---

## ⚙️ Environment Variables

| Variable | Description | Example |
|-----------|--------------|----------|
| `TS_AUTHKEY` | Tailscale auth key (required) | `tskey-auth-xxxx` |
| `TS_HOSTNAME` | Custom hostname (optional) | `server-tailscale` |
| `SOCAT_CMD` | Full socat command to run | `TCP-LISTEN:2283,fork TCP:immich-server:2283` |
| `WAIT_FOR` | Optional list of host:port to wait before running socat | `immich-server:2283` |

---

## 🧱 Example Docker Compose

```yaml
version: "3"
services:
  server-tailscale:
    image: ghcr.io/davcolme/server-tailscale:latest
    container_name: server-tailscale
    cap_add:
      - NET_ADMIN
      - NET_RAW
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY}
      - TS_HOSTNAME=server-tailscale
      - SOCAT_CMD=TCP-LISTEN:2283,fork TCP:immich-server:2283
      - WAIT_FOR=immich-server:2283
    volumes:
      - ./server-tailscale-stack/tailscale-data:/var/lib/tailscale
    restart: unless-stopped
