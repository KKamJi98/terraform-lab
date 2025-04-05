resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.14.3"
  depends_on = [
    kubernetes_service_account.external_secrets_irsa
  ]
}
