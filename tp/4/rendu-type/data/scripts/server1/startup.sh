#!/bin/bash

# Define main interface name
interface="eth1"

# Install webserver (NGINX)
sudo yum install -y nginx

# Be sure that the firewall is running
sudo systemctl start firewalld

# Open port for webserver (80/tcp)
sudo firewall-cmd --add-port=80/tcp --permanent
# Refresh firewall
sudo firewall-cmd --reload

# Start webserver (NGINX)
sudo systemctl start nginx

# Add route to remote net1
route="10.1.0.0/24 via 10.2.0.254 dev ${interface}"
sudo ip route add ${route}
echo ${route} | sudo tee /etc/sysconfig/network-scripts/route-${interface}

# Delete default route
sudo ip route del default

# Add new default route (through router1)
route="default via 10.2.0.254 dev ${interface}"
sudo ip route add ${route}
echo ${route} | sudo tee /etc/sysconfig/network-scripts/route-${interface}

# Copy hosts file
sudo cp /vagrant/data/hosts/server1/hosts /etc/hosts
