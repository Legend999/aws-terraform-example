resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name      = var.key_name
  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = var.name
  }

  user_data = file("${path.module}/user_data.sh")
}

resource "null_resource" "deploy_script" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "deploy.sh"
    destination = "/home/ubuntu/deploy.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = aws_instance.web.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/deploy.sh",
      "/home/ubuntu/deploy.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = aws_instance.web.public_ip
    }
  }

  depends_on = [aws_instance.web]
}
