###############################################################
# Pod Identity IAM Roles and Associations
###############################################################

resource "aws_iam_role" "ebs_csi_driver" {
  name = "kkamji-ebs-csi-driver-role"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    source_arn = local.pod_identity_source_arn
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_policy" "external_secrets_policy" {
  name        = "kkamji_external_secrets_policy"
  description = "Policy for External Secrets to access SSM Parameter Store and Secrets Manager"
  policy      = data.aws_iam_policy_document.external_secrets.json

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "external_secrets" {
  name = "kkamji_external_secrets"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    source_arn = local.pod_identity_source_arn
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "external_secrets_policy_attachment" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "kkamji-aws-lbc-policy"
  description = "Permissions for AWS Load Balancer Controller"
  policy      = file("${path.module}/templates/aws_load_balancer_policy.json")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "kkamji-aws-lbc-role"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    source_arn = local.pod_identity_source_arn
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

###############################################################
# ExternalDNS (Route53) - IAM Role/Policy and Pod Identity
###############################################################

resource "aws_iam_policy" "external_dns_policy" {
  name        = "kkamji-external-dns-policy"
  description = "Permissions for ExternalDNS to manage Route53 records"
  policy      = data.aws_iam_policy_document.external_dns.json

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "external_dns" {
  name = "kkamji-external-dns-role"
  assume_role_policy = templatefile("${path.module}/templates/pod_identity_assume_role_policy.tpl", {
    source_arn = local.pod_identity_source_arn
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }

  depends_on = [
    module.eks
  ]
}

resource "kubernetes_service_account" "external_secrets" {
  metadata {
    name      = "external-secrets"
    namespace = kubernetes_namespace.external_secrets.metadata[0].name
  }

  depends_on = [
    module.eks
  ]
}

resource "aws_eks_pod_identity_association" "external_secrets" {
  cluster_name    = local.cluster_name
  namespace       = kubernetes_namespace.external_secrets.metadata[0].name
  service_account = kubernetes_service_account.external_secrets.metadata[0].name
  role_arn        = aws_iam_role.external_secrets.arn

  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.external_secrets_policy_attachment
  ]
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  depends_on = [
    module.eks
  ]
}

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = local.cluster_name
  namespace       = kubernetes_service_account.aws_load_balancer_controller.metadata[0].namespace
  service_account = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  role_arn        = aws_iam_role.aws_load_balancer_controller.arn

  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]
}
