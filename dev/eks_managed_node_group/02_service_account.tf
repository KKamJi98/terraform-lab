######################################################################
## AWS Load Balancer Controller SA
######################################################################
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller-sa"
    namespace = "kube-system"
    labels = {
      terraform = "true"
    }
  }
}

# ######################################################################
# ## EBS CSI Driver SA
# ######################################################################
# resource "kubernetes_service_account" "ebs_csi_driver" {
#   metadata {
#     name      = "ebs-csi-driver-sa"
#     namespace = "kube-system"
#     labels = {
#       terraform = "true"
#     }
#   }
# }