# VPN Server - WireGuard & IKEv2/IPSec

Docker-based VPN server setups that can be deployed on your VPS with Dokploy. This repository includes:

1. **WireGuard Easy** - Modern VPN with web UI (requires app on Android)
2. **IKEv2/IPSec** - Native Android support (no app required)

---

## Option 1: WireGuard Easy

A Docker-based WireGuard VPN server setup using [wg-easy](https://github.com/wizki/wg-easy).

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

---

## Option 2: IKEv2/IPSec VPN (Native Android Support)

An IKEv2/IPSec VPN server using [hwdsl2/ipsec-vpn-server](https://github.com/hwdsl2/docker-ipsec-vpn-server) that works with Android's native VPN settings **without requiring any app**.

### Features

- ✅ **Native Android Support**: Works with Android's built-in VPN settings (no app needed!)
- ✅ **iOS Support**: Native support on iOS devices
- ✅ **Windows/macOS**: Works with built-in VPN clients
- ✅ **Secure**: IKEv2/IPSec protocol with certificate or PSK authentication
- ✅ **Easy Setup**: Simple Docker Compose configuration

### Prerequisites

- VPS with Docker and Docker Compose installed
- Dokploy installed on your VPS (or Docker directly)
- Firewall access to open ports (500/UDP and 4500/UDP)
- Your VPS public IP address or domain name
- IP forwarding enabled (already done on your VPS)

### Quick Start

#### 1. Configure Environment Variables

Copy the example environment file and edit it:

```bash
cp env-ikev2.example .env
nano .env  # or use your preferred editor
```

**Important variables to set:**
- `VPN_IPSEC_PSK`: A strong pre-shared key (generate with: `openssl rand -base64 32`)
- `VPN_USER`: Your VPN username
- `VPN_PASSWORD`: A strong VPN password

#### 2. Deploy with Dokploy

1. Log in to your Dokploy dashboard
2. Create a new application/project
3. Choose "Docker Compose" as the deployment method
4. Upload or paste the contents of `docker-compose-ikev2.yml`
5. Set the environment variables from your `.env` file:
   - `VPN_IPSEC_PSK`
   - `VPN_USER`
   - `VPN_PASSWORD`
6. Deploy the application

#### 3. Configure IKEv2 (After Initial Deployment)

After the container starts, you need to configure IKEv2:

```bash
# SSH into your VPS
ssh akvps

# Access the container
docker exec -it ipsec-vpn-server bash

# Run the IKEv2 setup script
wget https://git.io/ikev2setup -O ikev2.sh && bash ikev2.sh
```

Follow the prompts:
- Enter your server's public IP or domain: `207.154.195.244` (or your domain)
- Choose certificate type (recommended: ECDSA for better performance)
- Enter a name for the first client (e.g., "android")

#### 4. Configure Firewall

Open the necessary ports:

```bash
# UFW (Ubuntu)
sudo ufw allow 500/udp
sudo ufw allow 4500/udp

# Or for other firewalls
# Allow UDP port 500 (IKE)
# Allow UDP port 4500 (NAT traversal)
```

### Connecting from Android (Native - No App!)

1. Go to **Settings** → **Network & Internet** → **VPN**
2. Tap the **"+"** or **"Add VPN"** button
3. Fill in the details:
   - **Name**: Any name (e.g., "My VPN")
   - **Type**: **IKEv2/IPSec PSK**
   - **Server address**: Your VPS IP (e.g., `207.154.195.244`)
   - **IPSec pre-shared key**: The `VPN_IPSEC_PSK` value from your `.env`
   - **Username**: The `VPN_USER` value
   - **Password**: The `VPN_PASSWORD` value
4. Tap **Save**
5. Tap on the VPN profile to connect

### Alternative: Certificate-Based IKEv2 (More Secure)

For certificate-based authentication (no PSK needed):

1. **Copy the certificate from the container:**
   ```bash
   # From your VPS
   docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 ./vpnclient.p12
   ```

2. **Transfer the certificate to your Android device** (via USB, email, or cloud storage)

3. **On Android:**
   - Settings → Network & Internet → VPN → Add VPN
   - **Type**: **IKEv2/IPSec RSA**
   - **Server address**: Your VPS IP
   - **Import certificate**: Select the `vpnclient.p12` file
   - **Certificate password**: Enter the password shown during IKEv2 setup
   - **Username**: The `VPN_USER` value
   - **Password**: The `VPN_PASSWORD` value
   - Save and connect

### Connecting from Other Devices

#### iOS (Native Support)
1. Settings → General → VPN & Device Management → VPN
2. Add VPN Configuration
3. Type: IKEv2
4. Enter server, username, password, and PSK (or import certificate)

#### Windows (Native Support)
1. Settings → Network & Internet → VPN → Add VPN
2. VPN provider: Windows (built-in)
3. Connection name: Any name
4. Server name: Your VPS IP
5. VPN type: IKEv2
6. Enter username, password, and PSK

#### macOS (Native Support)
1. System Settings → Network → Add VPN
2. Interface: VPN
3. VPN Type: IKEv2
4. Enter server, username, password, and PSK

### Managing Users

To add more VPN users:

```bash
# Access the container
docker exec -it ipsec-vpn-server bash

# Add a new user
adduser vpnuser2
# Follow prompts to set password

# Or use the helper scripts in /opt/src
```

### Troubleshooting

#### Can't Connect from Android

1. **Check Firewall**: Ensure ports 500/UDP and 4500/UDP are open
   ```bash
   sudo ufw status
   ```

2. **Check Container Logs**:
   ```bash
   docker logs ipsec-vpn-server
   ```

3. **Verify IP Forwarding**: Should already be enabled, but check:
   ```bash
   sysctl net.ipv4.ip_forward  # Should return 1
   ```

4. **Check Container Status**:
   ```bash
   docker ps | grep ipsec
   ```

5. **Verify Credentials**: Double-check your PSK, username, and password match

#### Connection Drops Frequently

1. Check your VPS network stability
2. Verify firewall isn't blocking keepalive packets
3. Check container logs for errors

### Security Best Practices

1. **Strong PSK**: Use a long, random pre-shared key
2. **Strong Passwords**: Use complex passwords for VPN users
3. **Certificate Method**: Prefer certificate-based authentication over PSK
4. **Firewall**: Only open necessary ports
5. **Regular Updates**: Keep Docker images updated
6. **Backup Certificates**: Backup the `ikev2-vpn-data` volume

### Backup and Restore

#### Backup
```bash
# Backup IKEv2 configuration and certificates
docker run --rm -v vpn_ikev2-vpn-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/ikev2-backup-$(date +%Y%m%d).tar.gz -C /data .
```

#### Restore
```bash
# Stop the container
docker compose -f docker-compose-ikev2.yml down

# Restore from backup
docker run --rm -v vpn_ikev2-vpn-data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/ikev2-backup-YYYYMMDD.tar.gz -C /data

# Start the container
docker compose -f docker-compose-ikev2.yml up -d
```

### Stopping and Removing

```bash
# Stop the VPN server
docker compose -f docker-compose-ikev2.yml down

# Remove everything (including data)
docker compose -f docker-compose-ikev2.yml down -v
```

### Resources

- [hwdsl2/docker-ipsec-vpn-server GitHub](https://github.com/hwdsl2/docker-ipsec-vpn-server)
- [IKEv2 Setup Guide](https://github.com/hwdsl2/docker-ipsec-vpn-server#configure-and-use-ikev2-vpn)
- [Dokploy Documentation](https://docs.dokploy.com/)

---

## License

- WireGuard setup uses wg-easy which is licensed under the MIT License
- IKEv2 setup uses hwdsl2/ipsec-vpn-server which is licensed under the MIT License
