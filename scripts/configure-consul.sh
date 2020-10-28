#!/bin/bash

set -e

sudo mkdir --parents /etc/consul.d/ssl
sudo mv consul.hcl /etc/consul.d/consul.hcl
if [ -s "ca.pem" ]; then
  sudo mv ca.pem /etc/consul.d/ssl/ca.pem
fi
if [ -s "server.key" ]; then
  sudo mv server.key /etc/consul.d/ssl/server.key
fi
if [ -s "server.pem" ]; then
  sudo mv server.pem /etc/consul.d/ssl/server.pem
fi
if [ -s "cli.key" ]; then
  sudo mv cli.key /etc/consul.d/ssl/cli.key
fi
if [ -s "cli.pem" ]; then
  sudo mv cli.pem /etc/consul.d/ssl/cli.pem
fi
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl

sudo systemctl enable consul.service
sudo systemctl restart consul.service
sleep 5
sudo systemctl status consul.service --no-pager

until (curl http://127.0.0.1:8500/v1/status/leader 2>/dev/null | grep -E '".+"'); do
  echo "Waiting for Consul agent startup..."
  sleep 1
done