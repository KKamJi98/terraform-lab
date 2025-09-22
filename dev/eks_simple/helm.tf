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
  atomic     = true

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

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository      = "https://kubernetes-sigs.github.io/metrics-server/"
  chart           = "metrics-server"
  version         = "3.13.0"
  atomic          = true
  cleanup_on_fail = true

  set = [
    {
      name  = "apiService.create"
      value = "true"
    },
    {
      name  = "nodeSelector.node\\.kubernetes\\.io/app"
      value = "operation"
    }
  ]

  set_list = [
    {
      name = "defaultArgs"
      value = [
        "--cert-dir=/tmp",
        "--kubelet-insecure-tls",
        "--metric-resolution=60s",
        "--kubelet-preferred-address-types=InternalIP"
      ]
    }
  ]
}

resource "helm_release" "exteranl_dns" {
  name      = "external-dns"
  namespace = "external-dns"

  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  version          = "1.19.0"
  create_namespace = true
  cleanup_on_fail  = true

  set = [
    # {
    #   name  = "serviceAccount.name"
    #   value = "external-dns"
    # },
    {
      name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws.com/role-arn"
      value = aws_iam_role.external_dns.arn
    },
    {
      name  = "nodeSelector.node\\.kubernetes\\.io/app"
      value = "operation"
    },
    {
      name  = "extraArgs.exclude-record-types"
      value = "AAAA"
    },
    {
      name  = "policy"
      value = "upsert-only"
    },
    {
      name  = "provider.name"
      value = "aws"
    },
    {
      name  = "env[0].name"
      value = "AWS_DEFAULT_REGION"
    },
    {
      name  = "env[0].value"
      value = var.region
    }
  ]
}
