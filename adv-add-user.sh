#!/bin/bash

############################################################
# AD Proxy Installer
# Author: Flexeere
# Email: info@flexeere.com
# Github: https://github.com/flexeere/AD-Proxy/
# Web: https://flexeere.com
# If you need professional assistance, reach out to
# https://flexeere.com/order/contact.php
############################################################

set -euo pipefail

PASSWD_FILE="/etc/squid/passwd"

if [[ $(id -u) -ne 0 ]]; then
    echo "Run as root."
    exit 1
fi

if ! command -v htpasswd >/dev/null; then
    echo "htpasswd not found. Please install apache2-utils or httpd-tools."
    exit 1
fi

# Random username/password logic
USERNAME=$(tr -dc 'a-z' </dev/urandom | head -c8)
PASSWORD=$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c8)

htpasswd -b "$PASSWD_FILE" "$USERNAME" "$PASSWORD"
systemctl reload squid || systemctl restart squid

echo "==================================="
echo "Proxy user created!"
echo "Username: $USERNAME"
echo "Password: $PASSWORD"
echo "==================================="
