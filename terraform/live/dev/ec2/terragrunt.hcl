terraform {
  source = "../../../modules/ec2_instance"
}

inputs = {
  ami_id            = "ami-042b4708b1d05f512" # Ubuntu 24.04 for eu-north-1
  subnet_id         = "subnet-029d82b90212e9706"
  security_group_id = "sg-0a5be87136b5408be"
  key_name          = "dev-key"
  name              = "dev-nginx"
  private_key_path = "~/.ssh/dev-key.pem"
}

