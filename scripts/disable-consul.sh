#!/bin/bash

set -e

sudo systemctl stop consul.service
sudo systemctl disable consul.service