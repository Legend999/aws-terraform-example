#!/bin/bash

cloud-init status --wait

cd /home/ubuntu
if [ ! -d "aws-terraform-example" ]; then
  git clone https://github.com/Legend999/aws-terraform-example.git
fi

cd /home/ubuntu/aws-terraform-example/example-app
git reset --hard
git pull origin main
docker stop aws-terraform-example || true
docker rm aws-terraform-example || true
docker build -t aws-terraform-example .

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
export EC2_HOST=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

docker run -d -p 80:3000 -e EC2_HOST="$EC2_HOST" --name aws-terraform-example aws-terraform-example