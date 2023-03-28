module "cluster_system_vpc" {
  source = "./cluster-system/eks-cluster"

  # Input Variables
  instance_type = "t2.small"
}

module "cluster_system_iam_role" {
  source = "./cluster-system/iam-role"
}
