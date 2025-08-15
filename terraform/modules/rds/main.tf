data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name = "${var.name}-subnet-group"
  subnet_ids = [
    "subnet-06c308992b1c5e46a",
    "subnet-0257ed78a0929b339"
  ]
}

resource "aws_db_instance" "default" {
  identifier                  = var.name
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  username                    = "admin"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.default.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  skip_final_snapshot         = true
  publicly_accessible         = false

  tags = {
    Name = var.name
  }
}
