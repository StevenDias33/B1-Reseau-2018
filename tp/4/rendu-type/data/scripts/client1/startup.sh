#!/bin/bash

# Define main interface name
interface="eth1"

# Add route to remote net2
route="10.2.0.0/24 via 10.1.0.254 dev ${interface}"
sudo ip route add ${route}
echo ${route} | sudo tee /etc/sysconfig/network-scripts/route-${interface}

# Delete default route
sudo ip route del default

# Add new default route (through router1)
route="default via 10.1.0.254 dev ${interface}"
sudo ip route add ${route}
echo ${route} | sudo tee /etc/sysconfig/network-scripts/route-${interface}

# Copy hosts file
sudo cp /vagrant/data/hosts/client1/hosts /etc/hosts
