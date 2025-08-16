terraform {
  source = "../../modules/cloudwatch"
}

dependency "ec2" {
  config_path = "../ec2"
}

inputs = {
  app_name    = "url-shortener"
  aws_region  = "eu-north-1"
  instance_id = dependency.ec2.outputs.instance_id
}