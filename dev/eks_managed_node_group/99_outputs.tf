# output "cluster_name" {
#   value = module.eks.cluster_name
# }

# output "cluster_version" {
#   value = module.eks.cluster_version
# }

# output "cluster_primary_security_group_id" {
#   value       = module.eks.cluster_primary_security_group_id
#   description = "The ID of the primary security group of the EKS cluster"
# }

# output "cluster_service_cidr" {
#   value       = module.eks.cluster_service_cidr
#   description = "The CIDR block for the cluster service"
# }

# output "node_security_group_arn" {
#   description = "Amazon Resource Name (ARN) of the node shared security group"
#   value       = module.eks.node_security_group_arn
# }

# output "node_security_group_id" {
#   description = "ID of the node shared security group"
#   value       = module.eks.node_security_group_id
# }