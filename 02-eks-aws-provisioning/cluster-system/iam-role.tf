data "aws_iam_policy" "aws_eks_cluster_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "aws_eks_worker_node_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "aws_ec2_container_registry_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "aws_eks_cni_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

data "aws_iam_policy_document" "aws_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster_system_eks_cluster_role" {
  name = "cluster_system_eks_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.aws_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_system_attach_eks_policy" {
  role       = aws_iam_role.cluster_system_eks_cluster_role.name
  policy_arn = data.aws_iam_policy.aws_eks_cluster_policy.arn
}

resource "aws_iam_role" "cluster_system_eks_node_role" {
  name = "cluster_system_eks_node_role"
  assume_role_policy = data.aws_iam_policy_document.aws_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_system_attach_node_policy_1" {
  role       = aws_iam_role.cluster_system_eks_node_role.name
  policy_arn = data.aws_iam_policy.aws_eks_worker_node_policy.arn
}

resource "aws_iam_role_policy_attachment" "cluster_system_attach_node_policy_2" {
  role       = aws_iam_role.cluster_system_eks_node_role.name
  policy_arn = data.aws_iam_policy.aws_ec2_container_registry_policy.arn
}

resource "aws_iam_role_policy_attachment" "cluster_system_attach_node_policy_3" {
  role       = aws_iam_role.cluster_system_eks_node_role.name
  policy_arn = data.aws_iam_policy.aws_eks_cni_policy.arn
}
