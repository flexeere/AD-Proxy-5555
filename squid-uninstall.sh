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

[[ $(id -u) -eq 0 ]] || { echo "Run as root."; exit 1; }
[[ -f /usr/local/bin/sok-find-os ]] || { echo "sok-find-os missing"; exit 1; }

OS=$(/usr/local/bin/sok-find-os)
case "$OS" in
    ubuntu*|debian*)
        apt -y remove --purge squid squid3 squid-common squid-langpack || true
        rm -rf /etc/squid /etc/squid3 /var/spool/squid
        ;;
    centos*|almalinux*)
        (command -v dnf && dnf remove -y squid) || yum remove -y squid
        rm -rf /etc/squid /var/spool/squid
        ;;
    *)
        echo "Unknown OS"; exit 1
        ;;
esac

rm -f /usr/local/bin/squid-add-user /usr/local/bin/sok-find-os /usr/local/bin/squid-uninstall
echo "AD Proxy uninstalled. Thank you for using flexeere.com!"
