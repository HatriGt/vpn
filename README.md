# VPN Server - WireGuard Easy

A Docker-based WireGuard VPN server setup using [wg-easy](https://github.com/wizki/wg-easy) that can be deployed on your VPS with Dokploy.

## Features

- 🚀 **Easy Setup**: Simple Docker Compose configuration
- 🌐 **Web UI**: User-friendly web interface for managing clients
- 📱 **Mobile Support**: QR code generation for easy mobile setup
- 🔒 **Secure**: Modern WireGuard protocol (faster than OpenVPN)
- 🖥️ **Multi-Platform**: Works on Windows, macOS, Linux, iOS, and Android

## Prerequisites

- VPS with Docker and Docker Compose installed
- Dokploy installed on your VPS (or Docker directly)
- Firewall access to open ports (51820/UDP and 51821/TCP)
- Your VPS public IP address or domain name

## Quick Start

### 1. Clone or Download This Repository

```bash
git clone <your-repo-url>
cd vpn
```

### 2. Configure Environment Variables

Copy the example environment file and edit it:

```bash
cp env.example .env
nano .env  # or use your preferred editor
```

**Important variables to set:**
- `WG_HOST`: Your VPS public IP address or domain name
- `WG_PASSWORD`: A strong password for the web UI
- `WG_PORT`: WireGuard UDP port (default: 51820)
- `WG_WEB_PORT`: Web UI port (default: 51821)

### 3. Deploy with Dokploy

#### Option A: Using Dokploy Web Interface

1. Log in to your Dokploy dashboard
2. Create a new application/project
3. Choose "Docker Compose" as the deployment method
4. Upload or paste the contents of `docker-compose.yml`
5. Set the environment variables from your `.env` file
6. Deploy the application

#### Option B: Using Docker Compose Directly

If you prefer to deploy directly without Dokploy:

```bash
docker compose up -d
```

### 4. Enable IP Forwarding (Required)

On your VPS, enable IP forwarding:

```bash
# For Ubuntu/Debian
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.src_valid_mark=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 5. Configure Firewall

Open the necessary ports:

```bash
# UFW (Ubuntu)
sudo ufw allow 51820/udp
sudo ufw allow 51821/tcp

# Or for other firewalls
# Allow UDP port 51820 (WireGuard)
# Allow TCP port 51821 (Web UI)
```

### 6. Access the Web UI

Open your browser and navigate to:
```
http://your-vps-ip:51821
```

Login with the password you set in `WG_PASSWORD`.

## Usage

### Creating VPN Clients

1. Access the web UI at `http://your-vps-ip:51821`
2. Click "Add Client" or the "+" button
3. Enter a name for your client (e.g., "My iPhone", "Laptop")
4. Click "Create"
5. Download the configuration file or scan the QR code

### Connecting from Different Devices

#### Mobile (iOS/Android)
1. Install the WireGuard app from App Store/Play Store
2. Scan the QR code from the web UI
3. Enable the VPN connection

#### Desktop (Windows/macOS/Linux)
1. Install WireGuard client from [wireguard.com/install](https://www.wireguard.com/install/)
2. Import the downloaded `.conf` file
3. Connect to the VPN

### Managing Clients

- **View**: See all connected clients in the web UI
- **Edit**: Modify client settings (name, allowed IPs, etc.)
- **Delete**: Remove clients you no longer need
- **Download Config**: Re-download configuration files
- **View QR Code**: Display QR code for mobile setup

## Configuration Options

Edit your `.env` file to customize:

- **WG_DEFAULT_DNS**: Change DNS server (default: 1.1.1.1)
- **WG_ALLOWED_IPS**: Configure split tunneling
  - `0.0.0.0/0, ::/0` = Full tunnel (all traffic through VPN)
  - Specific IPs = Split tunnel (only route specific traffic)
- **WG_MTU**: Adjust MTU if experiencing connection issues
- **WG_PERSISTENT_KEEPALIVE**: Adjust keepalive interval

## Troubleshooting

### VPN Not Connecting

1. **Check Firewall**: Ensure port 51820/UDP is open
2. **Verify IP Forwarding**: Run `sysctl net.ipv4.ip_forward` (should return 1)
3. **Check Logs**: `docker compose logs wg-easy`
4. **Verify WG_HOST**: Make sure it's set to your actual VPS IP

### Web UI Not Accessible

1. **Check Port**: Ensure port 51821/TCP is open
2. **Check Container**: `docker compose ps`
3. **View Logs**: `docker compose logs wg-easy`

### Slow Connection

1. Try adjusting `WG_MTU` (try 1280 or 1200)
2. Check your VPS bandwidth
3. Verify DNS settings (`WG_DEFAULT_DNS`)

## Security Best Practices

1. **Strong Password**: Use a strong password for `WG_PASSWORD`
2. **Firewall**: Only open necessary ports
3. **Regular Updates**: Keep Docker images updated
4. **Backup Configs**: Backup the `wg-easy-data` directory
5. **Limit Access**: Consider restricting web UI access to specific IPs

## Backup and Restore

### Backup
```bash
# Backup WireGuard configuration
tar -czf wg-easy-backup-$(date +%Y%m%d).tar.gz wg-easy-data/
```

### Restore
```bash
# Stop the container
docker compose down

# Restore from backup
tar -xzf wg-easy-backup-YYYYMMDD.tar.gz

# Start the container
docker compose up -d
```

## Stopping and Removing

```bash
# Stop the VPN server
docker compose down

# Remove everything (including data)
docker compose down -v
```

## Resources

- [wg-easy GitHub Repository](https://github.com/wizki/wg-easy)
- [WireGuard Official Website](https://www.wireguard.com/)
- [WireGuard Installation Guides](https://www.wireguard.com/install/)
- [Dokploy Documentation](https://docs.dokploy.com/)

## License

This setup uses wg-easy which is licensed under the MIT License.
