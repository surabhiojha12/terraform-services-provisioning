resource "aws_instance" "web_system_ec2_instance_1" {
  ami               = var.ami
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.web_system_ec2_instances_security_group.id]
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.web_system_private_subnet.id
  user_data         = <<-EOF
              #!/bin/bash
              echo "Hello, World from instance 1" > index.html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "web_system_ec2_instance_2" {
  ami               = var.ami
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.web_system_ec2_instances_security_group.id]
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.web_system_private_subnet.id
  user_data         = <<-EOF
              #!/bin/bash
              echo "Hello, World from instance 2" > index.html
              python3 -m http.server 8080 &
              EOF
}
