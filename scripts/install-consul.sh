#!/bin/bash

set -e

# if [ "$(systemctl is-active consul.service)" == "active" ]; then
#   echo "Consul services is currently active."
#   COUNT=0
#   COUNT_MAX=20
#   while [ "$(curl --silent http://127.0.0.1:8500/v1/operator/autopilot/health | jq .FailureTolerance)" -lt "1" ]; do
#     COUNT=$((COUNT+1))
#     echo "Waiting for Consul cluster to become fault tolerant...(${COUNT}/${COUNT_MAX})"
#     sleep 1
#     if [ $COUNT == $COUNT_MAX ]; then 
#       exit 1
#     fi  
#   done
#   echo "Gracefully leaving Consul cluster before update."
#   consul leave
#   sudo systemctl stop consul.service
# fi

sudo chmod 755 consul
sudo chown root:root consul
sudo mv consul /usr/local/bin/
consul --version

consul -autocomplete-uninstall || true
consul -autocomplete-install
complete -C /usr/local/bin/consul consul