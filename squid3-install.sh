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

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

REPO="https://raw.githubusercontent.com/flexeere/AD-Proxy-5555/main"

# Ensure root privileges
[[ $(id -u) -eq 0 ]] || { echo -e "${RED}Run as root!${NC}"; exit 1; }

echo -e "${CYAN}AD Proxy Installer (Optimized)...${NC}"

# Install helper scripts (in parallel)
install_helpers() {
    declare -A scripts=(
        ["/usr/local/bin/sok-find-os"]="$REPO/sok-find-os.sh"
        ["/usr/local/bin/squid-uninstall"]="$REPO/squid-uninstall.sh"
        ["/usr/local/bin/adv-add-user"]="$REPO/adv-add-user.sh"
    )
    for path in "${!scripts[@]}"; do
        wget -q --no-check-certificate -O "$path" "${scripts[$path]}" &
    done
    wait
    chmod +x /usr/local/bin/sok-find-os /usr/local/bin/squid-uninstall /usr/local/bin/adv-add-user
}
install_helpers

# Check for existing install
if [[ -d /etc/squid || -d /etc/squid3 ]]; then
    echo -e "${GREEN}AD Proxy already installed.${NC}"; exit 0
fi

# Detect OS
[[ -f /usr/local/bin/sok-find-os ]] || { echo "sok-find-os missing"; exit 1; }
OS=$(/usr/local/bin/sok-find-os)
[[ "$OS" == "ERROR" ]] && { echo "Unsupported OS"; exit 1; }

# Install packages
case "$OS" in
    ubuntu*|debian*)
        apt update -qq
        if [[ "$OS" =~ ubuntu22 ]]; then
            apt -y install apache2-utils squid
        else
            apt -y install apache2-utils squid
        fi
        ;;
    centos*|almalinux*)
        (command -v dnf && dnf install -y squid httpd-tools wget) || yum install -y squid httpd-tools wget
        ;;
    *)
        echo -e "${RED}Unsupported OS${NC}"; exit 1
        ;;
esac

# Download Squid config
CONFIG_URL="$REPO/squid.conf"
if [[ "$OS" == "ubuntu2204" ]]; then
    CONFIG_URL="$REPO/conf/ubuntu-2204.conf"
elif [[ "$OS" == "debian12" ]]; then
    CONFIG_URL="$REPO/conf/debian12.conf"
elif [[ "$OS" == centos* || "$OS" == almalinux* ]]; then
    CONFIG_URL="$REPO/conf/squid-centos7.conf"
fi
mkdir -p /etc/squid
wget -q --no-check-certificate -O /etc/squid/squid.conf "$CONFIG_URL"
touch /etc/squid/passwd /etc/squid/blacklist.acl

# Open firewall port
if command -v iptables &>/dev/null; then
    iptables -C INPUT -p tcp --dport 5555 -j ACCEPT 2>/dev/null || iptables -I INPUT -p tcp --dport 5555 -j ACCEPT
fi
if command -v firewall-cmd &>/dev/null; then
    firewall-cmd --zone=public --permanent --add-port=5555/tcp || true
    firewall-cmd --reload || true
fi

# Enable/restart squid
systemctl enable squid || true
systemctl restart squid || true

# Create a proxy user
USER=$(tr -dc 'a-z' </dev/urandom | head -c8)
PW=$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c8)
htpasswd -b -c /etc/squid/passwd "$USER" "$PW"

# Finish
echo -e "${GREEN}Thank you for using AD Proxy Service.${NC}"
echo -e "${CYAN}Username: $USER\nPassword: $PW\nPort: 5555${NC}"
