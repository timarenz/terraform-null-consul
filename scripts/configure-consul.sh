#!/bin/bash

set -e

sudo mkdir --parents /etc/consul.d
sudo mv consul.json /etc/consul.d/consul.json
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.json

sudo systemctl enable consul.service
sudo systemctl restart consul.service
sleep 5
sudo systemctl status consul.service --no-pager 