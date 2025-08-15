terraform {
  source = "../../modules/rds"
}

inputs = {
  name                = "dev-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  vpc_id              = "vpc-0ffae8fb9f981cc15"
  security_group_name = "dev-rds-sg"
}
  