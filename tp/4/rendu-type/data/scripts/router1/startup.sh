#!/bin/bash

# Enable IP forwarding = turn this VM into a router
sysctl -w net.ipv4.conf.all.forwarding=1

# Disable firewalling
systemctl stop firewalld
systemctl disable firewalld

# Copy hosts file
sudo cp /vagrant/data/hosts/router1/hosts /etc/hosts
