#!/bin/bash

set -e

sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir --parents ${CONSUL_DATA_DIR}
sudo chown --recursive consul:consul ${CONSUL_DATA_DIR}

sudo touch /etc/systemd/system/consul.service

sudo tee /etc/systemd/system/consul.service <<EOF 
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF