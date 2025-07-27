variable "ami_id" {}
variable "instance_type" { default = "t3.micro" }
variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {}
variable "name" {}
variable "private_key_path" {}
variable "iam_instance_profile" {
  type = string
}