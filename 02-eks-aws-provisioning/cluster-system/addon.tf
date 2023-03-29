resource "aws_eks_addon" "cluster_system_eks_vpc_cni_addon" {
  cluster_name = aws_eks_cluster.cluster_system_eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "cluster_system_eks_coredns_addon" {
  cluster_name = aws_eks_cluster.cluster_system_eks_cluster.name
  addon_name = "coredns"
}

resource "aws_eks_addon" "cluster_system_eks_kube-proxy_addon" {
  cluster_name = aws_eks_cluster.cluster_system_eks_cluster.name
  addon_name = "kube-proxy"
}
