#!/bin/bash
# Author: info@flexeere.com
# Web: https://flexeere.com

set -euo pipefail

IP_ALL=$(/sbin/ip -4 -o addr show scope global | awk '{gsub(/\/.*/,"",$4); print $4}')
for IP in $IP_ALL; do
    ACL="proxy_ip_${IP//./_}"
    echo "acl $ACL myip $IP"
    echo "tcp_outgoing_address $IP $ACL"
done >> /etc/squid/squid.conf

systemctl restart squid
echo "Squid config updated with all local IPs."
