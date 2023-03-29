resource "aws_eks_node_group" "cluster_system_eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.cluster_system_eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.cluster_system_eks_node_role.arn
  subnet_ids      = [aws_subnet.cluster_system_private_subnet_1.id, aws_subnet.cluster_system_private_subnet_2.id]

  launch_template {
    id = aws_launch_template.cluster_system_launch_template.id
    version = aws_launch_template.cluster_system_launch_template.latest_version
  }
  
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_system_attach_node_policy_1,
    aws_iam_role_policy_attachment.cluster_system_attach_node_policy_2,
    aws_iam_role_policy_attachment.cluster_system_attach_node_policy_3
  ]

  tags = {
    Name = "cluster_system_eks_cluster_node_group"
  }
}
