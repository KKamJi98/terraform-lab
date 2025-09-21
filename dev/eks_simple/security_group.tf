resource "aws_security_group_rule" "eks_api_server_from_vpc" {
  description       = "Allow Kubernetes API server (443) from VPC CIDR"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = try(module.eks.cluster_security_group_id, module.eks.cluster_primary_security_group_id)
  cidr_blocks       = [data.aws_vpc.this.cidr_block]

  depends_on = [
    module.eks
  ]
}
