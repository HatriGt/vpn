#!/bin/bash

# Generate a strong pre-shared key for IKEv2/IPSec VPN

echo "Generating strong pre-shared key for IKEv2/IPSec VPN..."
echo ""
PSK=$(openssl rand -base64 32)
echo "Your VPN_IPSEC_PSK:"
echo "$PSK"
echo ""
echo "Add this to your .env file:"
echo "VPN_IPSEC_PSK=$PSK"
echo ""
