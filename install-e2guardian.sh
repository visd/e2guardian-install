#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Install dependencies
echo "Installing dependencies..."
apt-get install squid

echo "Installing e2guardian"
dpkg -i `dirname $0`/e2guardian_2.12.0.12-1_amd64.deb

echo "Copying system tuning..."
if [[ -d "/etc/sysctl.d/" && -f "`dirname $0`/tcp_tune.conf" ]]; then
    cp `dirname $0`/tcp_tune.conf /etc/sysctl.d/tcp_tune.conf
fi

# Create log dir and change ownership
echo "Creating e2guardian log directory..."
mkdir -p /var/log/e2guardian
chown -R nobody:nogroup /var/log/e2guardian/

# Copy init script into place
echo "Installing e2guardian init script"
cp `dirname $0`/e2guardian-init.d /etc/init.d/e2guardian
update-rc.d e2guardian defaults

# Copy logrotate script into place
echo "Installing e2guardian logrotate script"
cp `dirname $0`/e2guardian-logrotate.d /etc/logrotate.d/e2guardian

if [[ -f "`dirname $0`/squid.conf" ]]; then
    echo "Installing custom squid.conf"
    cp `dirname $0`/squid.conf /etc/squid/squid.conf
fi
