variable "cluster_name" {
  type        = string
  default     = "cluster-learn"
}

# EC2 Variables
variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-005f9685cb30f234b" # Amazon Linux - Free tier eligible
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro" # Free tier eligible
}
