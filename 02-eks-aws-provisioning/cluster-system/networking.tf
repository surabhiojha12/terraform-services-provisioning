# contains
# VPC
# Subnets
# Internet Gateway
# NAT Gateway
# Elastic IP
# Route table
# Security group

# VPC
resource "aws_vpc" "cluster_system" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "cluster_system"
  }
}

# public subnet
resource "aws_subnet" "cluster_system_public_subnet_1" {
  vpc_id     = aws_vpc.cluster_system.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cluster_system_public_subnet_1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
}

# public subnet 2
resource "aws_subnet" "cluster_system_public_subnet_2" {
  vpc_id     = aws_vpc.cluster_system.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cluster_system_public_subnet_2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
}

# private subnet
resource "aws_subnet" "cluster_system_private_subnet_1" {
  vpc_id     = aws_vpc.cluster_system.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cluster_system_private_subnet_1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# private subnet
resource "aws_subnet" "cluster_system_private_subnet_2" {
  vpc_id     = aws_vpc.cluster_system.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cluster_system_private_subnet_2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cluster_system_igw" {
  vpc_id = aws_vpc.cluster_system.id
  tags = {
    Name = "cluster_system_igw"
  }
}

# Route table - Public Subnet
resource "aws_route_table" "cluster_system_public_subnet_route_table" {
   # VPC ID
  vpc_id = aws_vpc.cluster_system.id

  # Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_system_igw.id
  }

  tags = {
    Name = "cluster_system_public_subnet_route_table"
  }  
}

# Associating Public Subnet to Route table
resource "aws_route_table_association" "cluster_system_public_subnet_1_association" {
  subnet_id      = aws_subnet.cluster_system_public_subnet_1.id
  route_table_id = aws_route_table.cluster_system_public_subnet_route_table.id
}

resource "aws_route_table_association" "cluster_system_public_subnet_2_association" {
  subnet_id      = aws_subnet.cluster_system_public_subnet_2.id
  route_table_id = aws_route_table.cluster_system_public_subnet_route_table.id
}

# Elastic IP - to give public IP to Public NAT
resource "aws_eip" "cluster_system_eip_nat" {
  vpc = true
  tags = {
    Name = "cluster_system_eip_nat"
  }  
}

# Public NAT
resource "aws_nat_gateway" "cluster_system_nat" {
  allocation_id = aws_eip.cluster_system_eip_nat.id
  subnet_id     = aws_subnet.cluster_system_public_subnet_1.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cluster_system_igw]
  tags = {
    Name = "cluster_system_nat"
  }  
}

# Elastic IP - to give public IP to Public NAT 2
resource "aws_eip" "cluster_system_eip_nat_2" {
  vpc = true
  tags = {
    Name = "cluster_system_eip_nat"
  }  
}

# Public NAT 2
resource "aws_nat_gateway" "cluster_system_nat_2" {
  allocation_id = aws_eip.cluster_system_eip_nat_2.id
  subnet_id     = aws_subnet.cluster_system_public_subnet_2.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cluster_system_igw]
  tags = {
    Name = "cluster_system_nat_two"
  }  
}

# Route table - Private Subnet
resource "aws_route_table" "cluster_system_private_subnet_route_table" {
   # VPC ID
  vpc_id = aws_vpc.cluster_system.id

  # Rule
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cluster_system_nat.id
  }

  tags = {
    Name = "cluster_system_private_subnet_route_table"
  }  
}

# Associating Private Subnet to Route table
resource "aws_route_table_association" "cluster_system_private_subnet_association" {
  subnet_id      = aws_subnet.cluster_system_private_subnet_1.id
  route_table_id = aws_route_table.cluster_system_private_subnet_route_table.id
}

# Route table 2 - Private Subnet
resource "aws_route_table" "cluster_system_private_subnet_route_table_2" {
   # VPC ID
  vpc_id = aws_vpc.cluster_system.id

  # Rule
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cluster_system_nat_2.id
  }

  tags = {
    Name = "cluster_system_private_subnet_route_table_two"
  }  
}

# Associating Private Subnet to Route table
resource "aws_route_table_association" "cluster_system_private_subnet_association_two" {
  subnet_id      = aws_subnet.cluster_system_private_subnet_2.id
  route_table_id = aws_route_table.cluster_system_private_subnet_route_table_2.id
}

# Security group for - EC2
resource "aws_security_group" "cluster_system_ec2_instances_security_group" {
  name = "web-system-ec2-instances-security-group"
  description = "This Security Group is for EC2 instances"
  vpc_id = aws_vpc.cluster_system.id
}

# Security group inbound rule for EC2
resource "aws_security_group_rule" "cluster_system_ec2_instances_inbound_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_system_ec2_instances_security_group.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
}

# Security group outbound rule for EC2
resource "aws_security_group_rule" "cluster_system_ec2_instances_outbound_rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster_system_ec2_instances_security_group.id
}
