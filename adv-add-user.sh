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

if [[ $(id -u) -ne 0 ]]; then
    echo "Run as root."
    exit 1
fi

read -p "Enter username: " USERNAME
read -s -p "Enter password: " PASSWORD
echo
[[ -z "$USERNAME" || -z "$PASSWORD" ]] && { echo "No blank fields."; exit 1; }

htpasswd -b /etc/squid/passwd "$USERNAME" "$PASSWORD"
systemctl reload squid || systemctl restart squid

echo "User $USERNAME added to Squid proxy."
