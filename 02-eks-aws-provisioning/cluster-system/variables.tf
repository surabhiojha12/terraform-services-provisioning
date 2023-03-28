variable "cluster_name" {
  type        = string
  default     = "cluster-learn"
}

variable "node_group_name" {
  type        = string
  default     = "cluster-learn-auto-scaling-node-group"
}

# EC2 Variables
variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-00c39f71452c08778" # Amazon Linux - Free tier eligible
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.medium"
}
