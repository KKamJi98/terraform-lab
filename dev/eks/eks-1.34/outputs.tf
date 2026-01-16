output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "EKS OIDC issuer URL"
}

output "karpenter_controller_role_arn" {
  value       = aws_iam_role.karpenter_controller.arn
  description = "Karpenter controller IAM role ARN"
}

output "karpenter_node_role_name" {
  value       = aws_iam_role.karpenter_node.name
  description = "Karpenter node IAM role name"
}

output "karpenter_interruption_queue_name" {
  value       = aws_sqs_queue.karpenter_interruption.name
  description = "Karpenter interruption SQS queue name"
}

output "karpenter_interruption_queue_arn" {
  value       = aws_sqs_queue.karpenter_interruption.arn
  description = "Karpenter interruption SQS queue ARN"
}
