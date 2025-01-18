output "cluster_primary_security_group_id" {
  value = module.eks_managed_node_group.cluster_primary_security_group_id
  description = "The ID of the primary security group of the EKS cluster"
}