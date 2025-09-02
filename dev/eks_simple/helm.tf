# resource "helm_release" "external-secrets" {
#   name             = "external-secrets"
#   namespace        = "external-secrets"
#   create_namespace = true

#   repository = "https://charts.external-secrets.io"
#   chart      = "external-secrets"
#   version    = "0.14.3"
#   depends_on = [
#     kubernetes_service_account.external_secrets_irsa
#   ]
# }

resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  namespace        = "kube-system"
  create_namespace = false

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.11.0"

  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    }
  ]

  depends_on = [
    module.eks
  ]
}
