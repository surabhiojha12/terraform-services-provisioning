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
resource "aws_subnet" "web_system_public_subnet" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "web_system"
  } 
}

# private subnet
resource "aws_subnet" "web_system_private_subnet" {
  vpc_id     = aws_vpc.web_system.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "web_system"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "web_system_igw" {
  vpc_id = aws_vpc.web_system.id
  tags = {
    Name = "web_system"
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
    Name = "web_system"
  }  
}

# Associating Public Subnet to Route table
resource "aws_route_table_association" "web_system_public_subnet_association" {
  subnet_id      = aws_subnet.web_system_public_subnet.id
  route_table_id = aws_route_table.web_system_public_subnet_route_table.id
}

# Elastic IP - to give public IP to Public NAT
resource "aws_eip" "web_system_eip_nat" {
  vpc = true
  tags = {
    Name = "web_system"
  }  
}

# Public NAT
resource "aws_nat_gateway" "web_system_nat" {
  allocation_id = aws_eip.web_system_eip_nat.id
  subnet_id     = aws_subnet.web_system_public_subnet.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.web_system_igw]
  tags = {
    Name = "web_system"
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
    Name = "web_system"
  }  
}

# Associating Private Subnet to Route table
resource "aws_route_table_association" "web_system_private_subnet_association" {
  subnet_id      = aws_subnet.web_system_private_subnet.id
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

