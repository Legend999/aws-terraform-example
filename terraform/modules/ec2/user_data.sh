#!/bin/bash
apt-get update -y
apt-get install -y docker.io git curl
usermod -aG docker ubuntu
newgrp docker
systemctl start docker
systemctl enable docker
