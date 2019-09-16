#!/bin/bash

set -e

sudo mkdir --parents /etc/consul.d
sudo mv consul.hcl /etc/consul.d/consul.hcl
if [ -f "ca.pem" ]; then
  sudo mv ca.pem /etc/consul.d/ca.pem
fi
if [ -f "ca.pem" ]; then
  sudo mv ca.pem /etc/consul.d/ca.pem
fi
if [ -f "server.key" ]; then
  sudo mv server.key /etc/consul.d/server.key
fi
if [ -f "server.pem" ]; then
  sudo mv server.pem /etc/consul.d/server.pem
fi
if [ -f "cli.key" ]; then
  sudo mv cli.key /etc/consul.d/cli.key
fi
if [ -f "cli.pem" ]; then
  sudo mv cli.pem /etc/consul.d/cli.pem
fi
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

sudo systemctl enable consul.service
sudo systemctl restart consul.service
sleep 5
sudo systemctl status consul.service --no-pager 