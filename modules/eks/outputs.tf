output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS cluster endpoint"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "EKS cluster CA data"
}

output "cluster_oidc_issuer_url" {
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
  description = "OIDC issuer URL"
}

output "oidc_provider_arn" {
  value       = try(aws_iam_openid_connect_provider.this[0].arn, null)
  description = "OIDC provider ARN (null if disabled)"
}

output "node_group_names" {
  value       = keys(aws_eks_node_group.managed)
  description = "Managed node group names"
}

output "node_group_arns" {
  value       = { for name, ng in aws_eks_node_group.managed : name => ng.arn }
  description = "Managed node group ARNs"
}

output "cluster_log_group_name" {
  value       = try(aws_cloudwatch_log_group.cluster[0].name, null)
  description = "Control plane log group name (null if disabled)"
}

output "cluster_log_group_arn" {
  value       = try(aws_cloudwatch_log_group.cluster[0].arn, null)
  description = "Control plane log group ARN (null if disabled)"
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description = "Cluster security group ID"
}

output "node_security_group_id" {
  value       = aws_security_group.node.id
  description = "Node security group ID"
}

output "node_role_arn" {
  value       = aws_iam_role.node_group.arn
  description = "Managed node group IAM role ARN"
}
