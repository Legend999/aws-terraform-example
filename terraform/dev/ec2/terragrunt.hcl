terraform {
  source = "../../modules/ec2"
}

dependency "iam" {
  config_path = "../iam"
}

dependency "rds" {
  config_path = "../rds"
}

inputs = {
  ami_id = "ami-042b4708b1d05f512" # Ubuntu 24.04 for eu-north-1
  instance_type        = "t3.micro"
  subnet_id            = "subnet-029d82b90212e9706"
  vpc_id               = "vpc-0ffae8fb9f981cc15"
  security_group_id    = "sg-0a5be87136b5408be"
  key_name             = "dev-key"
  name                 = "dev-nginx"
  private_key_path     = "~/.ssh/dev-key.pem"
  iam_instance_profile = dependency.iam.outputs.iam_instance_profile
  rds_endpoint         = dependency.rds.outputs.endpoint
  rds_sg_id            = dependency.rds.outputs.rds_security_group_id
}

