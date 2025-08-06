variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "name" {
  type = string
}

variable "ecr_image" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "ec2_host" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}