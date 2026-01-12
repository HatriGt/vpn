# IKEv2/IPSec VPN Setup Guide

This guide provides detailed step-by-step instructions for setting up IKEv2/IPSec VPN server with native Android support.

## Quick Setup Checklist

- [ ] Deploy container using `docker-compose-ikev2.yml`
- [ ] Configure environment variables (PSK, username, password)
- [ ] Open firewall ports (500/UDP, 4500/UDP)
- [ ] Run IKEv2 setup script inside container
- [ ] Configure Android device (native settings)
- [ ] Test connection

## Detailed Setup Steps

### Step 1: Generate Strong Pre-Shared Key

```bash
# Generate a strong PSK
openssl rand -base64 32
```

Copy this value to your `.env` file as `VPN_IPSEC_PSK`.

### Step 2: Deploy in Dokploy

1. **Create New Application in Dokploy**
   - Name: "IKEv2 VPN Server"
   - Type: Docker Compose

2. **Upload docker-compose-ikev2.yml**
   - Copy the contents of `docker-compose-ikev2.yml`
   - Paste into Dokploy's Docker Compose editor

3. **Set Environment Variables**
   ```
   VPN_IPSEC_PSK=<your-generated-psk>
   VPN_USER=<your-username>
   VPN_PASSWORD=<your-strong-password>
   ```

4. **Deploy**

### Step 3: Configure IKEv2

After deployment, SSH into your VPS and run:

```bash
# Access the container
docker exec -it ipsec-vpn-server bash

# Download and run IKEv2 setup
wget https://git.io/ikev2setup -O ikev2.sh && bash ikev2.sh
```

**Setup Script Prompts:**

1. **Server address**: Enter your VPS public IP or domain
   - Example: `207.154.195.244` or `vpn.yourdomain.com`

2. **Certificate type**: Choose one
   - `1` - RSA (2048-bit) - More compatible
   - `2` - ECDSA (P-256) - Better performance (recommended)

3. **Client name**: Enter a name for the first client
   - Example: `android`, `iphone`, `laptop`

4. **Certificate password**: Set a password for the certificate file
   - Remember this if you want to use certificate-based auth

The script will generate:
- Server certificate
- Client certificate (`.p12` file)
- Configuration files

### Step 4: Android Configuration (PSK Method)

**This method uses pre-shared key - simpler but less secure**

1. On your Android device:
   - Settings → Network & Internet → VPN
   - Tap "+" or "Add VPN"

2. Fill in:
   ```
   Name: My VPN (or any name)
   Type: IKEv2/IPSec PSK
   Server address: 207.154.195.244
   IPSec pre-shared key: <your-VPN_IPSEC_PSK-value>
   Username: <your-VPN_USER-value>
   Password: <your-VPN_PASSWORD-value>
   ```

3. Save and connect

### Step 5: Android Configuration (Certificate Method)

**This method uses certificate - more secure**

1. **Copy certificate from container:**
   ```bash
   docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 ./vpnclient.p12
   ```

2. **Transfer to Android:**
   - Email it to yourself
   - Use USB file transfer
   - Upload to cloud storage and download on Android

3. **On Android:**
   - Settings → Network & Internet → VPN
   - Tap "+" or "Add VPN"
   - Fill in:
     ```
     Name: My VPN
     Type: IKEv2/IPSec RSA
     Server address: 207.154.195.244
     Import certificate: Select vpnclient.p12 file
     Certificate password: <password-from-setup>
     Username: <your-VPN_USER-value>
     Password: <your-VPN_PASSWORD-value>
     ```

4. Save and connect

## Adding More Users

To add additional VPN users:

```bash
# Access container
docker exec -it ipsec-vpn-server bash

# Add new user
adduser vpnuser2
# Follow prompts to set password

# The new user can use the same PSK and their own username/password
```

## Testing Connection

1. **On Android:**
   - Connect to the VPN
   - Open a browser and visit [whatismyip.com](https://whatismyip.com)
   - Should show your VPS IP address

2. **Check Container Logs:**
   ```bash
   docker logs ipsec-vpn-server
   ```

3. **Verify Traffic:**
   - Try browsing websites
   - Check if your real IP is hidden

## Common Issues and Solutions

### Issue: "Connection failed" on Android

**Solutions:**
1. Verify firewall ports are open:
   ```bash
   sudo ufw status
   # Should show 500/udp and 4500/udp as ALLOW
   ```

2. Check container is running:
   ```bash
   docker ps | grep ipsec
   ```

3. Verify credentials match exactly (case-sensitive)

4. Check container logs:
   ```bash
   docker logs ipsec-vpn-server
   ```

### Issue: Connection drops frequently

**Solutions:**
1. Check VPS network stability
2. Verify IP forwarding is enabled:
   ```bash
   sysctl net.ipv4.ip_forward  # Should return 1
   ```

3. Check for firewall blocking keepalive packets

### Issue: Can't access internet through VPN

**Solutions:**
1. Verify IP forwarding:
   ```bash
   sysctl net.ipv4.ip_forward
   ```

2. Check container logs for routing errors

3. Verify firewall allows forwarded traffic

### Issue: Certificate import fails on Android

**Solutions:**
1. Ensure certificate file is not corrupted
2. Try downloading certificate again from container
3. Verify certificate password is correct
4. Try PSK method instead

## Security Recommendations

1. **Use Certificate Method**: More secure than PSK
2. **Strong Passwords**: Use complex passwords for VPN users
3. **Regular Updates**: Keep Docker image updated
4. **Backup Certificates**: Regularly backup the `ikev2-vpn-data` volume
5. **Limit Users**: Only create accounts for trusted users
6. **Monitor Logs**: Regularly check container logs for suspicious activity

## Advanced Configuration

### Custom DNS

Edit the container's configuration to use custom DNS servers.

### Split Tunneling

Configure which traffic goes through VPN and which doesn't (requires advanced routing setup).

### Multiple Server IPs

Configure the server to work with multiple IP addresses or domains.

For advanced configurations, refer to the [official documentation](https://github.com/hwdsl2/docker-ipsec-vpn-server).

## Maintenance

### Update Container

```bash
# Pull latest image
docker compose -f docker-compose-ikev2.yml pull

# Restart container
docker compose -f docker-compose-ikev2.yml up -d
```

### View Logs

```bash
# Real-time logs
docker logs -f ipsec-vpn-server

# Last 100 lines
docker logs --tail 100 ipsec-vpn-server
```

### Restart Container

```bash
docker compose -f docker-compose-ikev2.yml restart
```

## Support

For issues specific to the Docker image:
- [GitHub Issues](https://github.com/hwdsl2/docker-ipsec-vpn-server/issues)
- [Documentation](https://github.com/hwdsl2/docker-ipsec-vpn-server)
