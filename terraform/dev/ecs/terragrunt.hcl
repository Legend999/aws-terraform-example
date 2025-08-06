terraform {
  source = "../../modules/ecs"
}

dependency "iam" {
  config_path = "../iam"
}

dependency "ec2" {
  config_path = "../ec2"
}

inputs = {
  ami_id                = "ami-042b4708b1d05f512"
  instance_type         = "t3.micro"
  subnet_id             = "subnet-029d82b90212e9706"
  key_name              = "dev-key"
  name                  = "ecs-cluster"
  ecr_image             = "969702371059.dkr.ecr.eu-north-1.amazonaws.com/aws-terraform-example:latest"
  task_execution_role_arn = "arn:aws:iam::969702371059:role/ecsTaskExecutionRole"
  ec2_host              = dependency.ec2.outputs.public_ip
  iam_instance_profile_name = dependency.iam.outputs.iam_instance_profile
}
