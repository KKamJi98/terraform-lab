# ############################################
# # EKS Cluster Security Group
# ############################################
# resource "aws_security_group" "eks_cluster_sg" {
#   name        = "eks-cluster-sg"
#   description = "EKS Control Plane Security Group"
#   vpc_id      = data.terraform_remote_state.basic.outputs.vpc_id

#   # Access to API Server (443/TCP)
#   ingress {
#     description = "API access from management CIDRs"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = var.public_access_cidrs
#   }

#   # Control Plane Outbound – AWS 서비스 및 노드 통신
#   egress {
#     description = "Outbound to workers / AWS APIs"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "eks-cluster-sg"
#   }
# }

# ############################################
# # EKS Node Security Group
# ############################################
# resource "aws_security_group" "eks_node_sg" {
#   name        = "eks-node-sg"
#   description = "EKS Managed Nodes SG"
#   vpc_id      = data.terraform_remote_state.basic.outputs.vpc_id

#   # Node to Node / Pod to Pod (VPC 내부)
#   ingress {
#     description = "Node to Node and Pod to Pod network"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [data.terraform_remote_state.basic.outputs.vpc_cidr_block]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = { Name = "eks-node-sg" }
# }

# ############################################
# # 3. Security Group Rules
# ############################################
# # Node to Control Plane (443, https)
# resource "aws_security_group_rule" "node_to_control_plane_https" {
#   type                     = "ingress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_cluster_sg.id
#   source_security_group_id = aws_security_group.eks_node_sg.id
# }

# # Node to Control Plane (1025‑65535)
# resource "aws_security_group_rule" "node_to_control_plane_ephemeral" {
#   type                     = "ingress"
#   from_port                = 1025
#   to_port                  = 65535
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_cluster_sg.id
#   source_security_group_id = aws_security_group.eks_node_sg.id
# }

# # Control Plane to Node (1025‑65535)
# resource "aws_security_group_rule" "control_plane_to_node_ephemeral" {
#   type                     = "ingress"
#   from_port                = 1025
#   to_port                  = 65535
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_node_sg.id
#   source_security_group_id = aws_security_group.eks_cluster_sg.id
# }