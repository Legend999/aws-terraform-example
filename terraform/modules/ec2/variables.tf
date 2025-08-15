variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "vpc_id" {
  type = string
}
variable "security_group_id" {}
variable "key_name" {}
variable "name" {}
variable "private_key_path" {}
variable "iam_instance_profile" {
  type = string
}

variable "rds_endpoint" {
  type    = string
  default = ""
}

variable "rds_sg_id" {
  type    = string
  default = ""
}
