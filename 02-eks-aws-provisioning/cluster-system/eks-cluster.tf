resource "aws_eks_cluster" "cluster_system_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_system_eks_cluster_role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = [aws_subnet.cluster_system_private_subnet_1.id,
                  aws_subnet.cluster_system_private_subnet_2.id,
                  aws_subnet.cluster_system_public_subnet_2.id,
                  aws_subnet.cluster_system_public_subnet_1.id,
                  ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_system_attach_eks_policy
  ]

tags = {
    Name = "cluster_system_eks_cluster"
  }
}

