# conatins
# VPC
# Subnets
# Internet Gateway
# NAT Gateway
# Elastic IP
# Route table
# Security group
# Load Balancers

# VPC
resource "aws_vpc" "web_system" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "web_system"
  }
}

# public subnet
resource "aws_subnet" "web_system_public_subnet_1" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "web_system_public_subnet_1"
  } 
}

# public subnet 2
resource "aws_subnet" "web_system_public_subnet_2" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "web_system_public_subnet_2"
  } 
}

# private subnet
resource "aws_subnet" "web_system_private_subnet_1" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "web_system_private_subnet_1"
  }
}

# private subnet
resource "aws_subnet" "web_system_private_subnet_2" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "web_system_private_subnet_2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "web_system_igw" {
  vpc_id = aws_vpc.web_system.id
  tags = {
    Name = "web_system_igw"
  }
}

# Route table - Public Subnet
resource "aws_route_table" "web_system_public_subnet_route_table" {
   # VPC ID
  vpc_id = aws_vpc.web_system.id

  # Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_system_igw.id
  }

  tags = {
    Name = "web_system_public_subnet_route_table"
  }  
}

# Associating Public Subnet to Route table
resource "aws_route_table_association" "web_system_public_subnet_1_association" {
  subnet_id      = aws_subnet.web_system_public_subnet_1.id
  route_table_id = aws_route_table.web_system_public_subnet_route_table.id
}

resource "aws_route_table_association" "web_system_public_subnet_2_association" {
  subnet_id      = aws_subnet.web_system_public_subnet_2.id
  route_table_id = aws_route_table.web_system_public_subnet_route_table.id
}

# Elastic IP - to give public IP to Public NAT
resource "aws_eip" "web_system_eip_nat" {
  vpc = true
  tags = {
    Name = "web_system_eip_nat"
  }  
}

# Public NAT
resource "aws_nat_gateway" "web_system_nat" {
  allocation_id = aws_eip.web_system_eip_nat.id
  subnet_id     = aws_subnet.web_system_public_subnet_1.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.web_system_igw]
  tags = {
    Name = "web_system_nat"
  }  
}

# Route table - Private Subnet
resource "aws_route_table" "web_system_private_subnet_route_table" {
   # VPC ID
  vpc_id = aws_vpc.web_system.id

  # Rule
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_system_nat.id
  }

  tags = {
    Name = "web_system_private_subnet_route_table"
  }  
}

# Associating Private Subnet to Route table
resource "aws_route_table_association" "web_system_private_subnet_association" {
  subnet_id      = aws_subnet.web_system_private_subnet_1.id
  route_table_id = aws_route_table.web_system_private_subnet_route_table.id
}

# Security group for ALB - load balancer
resource "aws_security_group" "web_system_alb_security_group" {
  name = "web_system_alb_security_group"
  description = "This Security Group is for ALB"
  vpc_id = aws_vpc.web_system.id
}

# Security group inbound rule for ALB - load balancer
resource "aws_security_group_rule" "web_system_allow_alb_http_inbound" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_system_alb_security_group.id
}

# Security group outbound rule for ALB - load balancer
resource "aws_security_group_rule" "web_system_allow_alb_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_system_alb_security_group.id
}

# ALB Listener - load balancer
resource "aws_lb_listener" "web_system_http_listener" {
  load_balancer_arn = aws_lb.web_system_application_load_balancer.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# ALB target group - load balancer
resource "aws_lb_target_group" "web_system_alb_target_group_1" {
  name        = "web-system-alb-target-group-for-ec2-call-to-internet"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.web_system.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "web_system_alb_target_group_2" {
  name        = "web-system-alb-target-group-private"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.web_system.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ALB target attachment - Attach EC2 instances to target group of ALB
resource "aws_lb_target_group_attachment" "web_system_alb_ec2_instance_1" {
  target_group_arn = aws_lb_target_group.web_system_alb_target_group_1.arn
  target_id        = aws_instance.web_system_ec2_instance_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "web_system_ec2_instance_2" {
  target_group_arn = aws_lb_target_group.web_system_alb_target_group_2.arn
  target_id        = aws_instance.web_system_ec2_instance_2.id
  port             = 8080
}

# ALB Listener rule - load balancer
resource "aws_lb_listener_rule" "web_system_alb_listener_rule_public_server" {
  listener_arn = aws_lb_listener.web_system_http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/public/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_system_alb_target_group_1.arn
  }
}

resource "aws_lb_listener_rule" "web_system_alb_listener_rule_private_server" {
  listener_arn = aws_lb_listener.web_system_http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/private/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_system_alb_target_group_2.arn
  }
}

# ALB
resource "aws_lb" "web_system_application_load_balancer" {
  name               = "web-system-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.web_system_public_subnet_1.id, aws_subnet.web_system_public_subnet_2.id]
  security_groups    = [aws_security_group.web_system_alb_security_group.id]
}

# Security group for - EC2
resource "aws_security_group" "web_system_ec2_instances_security_group" {
  name = "web-system-ec2-instances-security-group"
  description = "This Security Group is for EC2 instances"
  vpc_id = aws_vpc.web_system.id
}

# Security group inbound rule for EC2
resource "aws_security_group_rule" "web_system_ec2_instances_inbound_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.web_system_ec2_instances_security_group.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  source_security_group_id = aws_security_group.web_system_alb_security_group.id
}

# Security group outbound rule for EC2
resource "aws_security_group_rule" "web_system_ec2_instances_outbound_rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_system_ec2_instances_security_group.id
}
