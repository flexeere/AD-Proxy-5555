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

source /etc/os-release

case "$PRETTY_NAME" in
    *"Ubuntu 22.04"*) echo "ubuntu2204" ;;
    *"Ubuntu 20.04"*) echo "ubuntu2004" ;;
    *"Ubuntu 18.04"*) echo "ubuntu1804" ;;
    *"Ubuntu 16.04"*) echo "ubuntu1604" ;;
    *"Ubuntu 14.04"*) echo "ubuntu1404" ;;
    *"jessie"*) echo "debian8" ;;
    *"stretch"*) echo "debian9" ;;
    *"buster"*) echo "debian10" ;;
    *"bullseye"*) echo "debian11" ;;
    *"bookworm"*) echo "debian12" ;;
    *"CentOS Linux 7"*) echo "centos7" ;;
    *"CentOS Linux 8"*) echo "centos8" ;;
    *"AlmaLinux 8"*) echo "almalinux8" ;;
    *"AlmaLinux 9"*) echo "almalinux9" ;;
    *"CentOS Stream 8"*) echo "centos8s" ;;
    *"CentOS Stream 9"*) echo "centos9" ;;
    *) echo "ERROR" ;;
esac
