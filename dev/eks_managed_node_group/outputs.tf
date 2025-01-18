output "cluster_primary_security_group_id" {
  value = module.eks_managed_node_group.cluster_primary_security_group_id
  description = "The ID of the primary security group of the EKS cluster"
}

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the node shared security group"
  value       = module.eks_managed_node_group.node_security_group_arn
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks_managed_node_group.node_security_group_id
}