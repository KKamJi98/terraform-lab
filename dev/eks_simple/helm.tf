resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "1.13.0"
  namespace        = "kube-system"
  create_namespace = false
  wait             = true
  timeout          = 600
  atomic           = true

  set = [
    {
      name  = "clusterName"
      value = local.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
    }
  ]

  depends_on = [
    module.eks,
    kubernetes_service_account.aws_load_balancer_controller,
    aws_eks_pod_identity_association.aws_load_balancer_controller,
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]
}

resource "helm_release" "external_secrets" {
  name      = "external-secrets"
  namespace = kubernetes_namespace.external_secrets.metadata[0].name

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.14.3"

  create_namespace = false

  set = [
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.external_secrets.metadata[0].name
    }
  ]

  depends_on = [
    module.eks,
    kubernetes_service_account.external_secrets,
    aws_eks_pod_identity_association.external_secrets,
    aws_iam_role_policy_attachment.external_secrets_policy_attachment,
    helm_release.aws_load_balancer_controller
  ]
}
