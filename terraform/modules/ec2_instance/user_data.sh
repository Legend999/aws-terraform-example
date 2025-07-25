#!/bin/bash
apt-get update -y
apt-get install -y docker.io git curl
systemctl start docker
systemctl enable docker

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
export EC2_HOST=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

cd /home/ubuntu
git clone https://github.com/Legend999/aws-terraform-example.git
cd example-app
docker build -t aws-terraform-example .

docker run -d -p 80:3000 -e EC2_HOST="$EC2_HOST" aws-terraform-example