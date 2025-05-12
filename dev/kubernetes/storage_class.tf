# https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/examples/kubernetes/storageclass/manifests

########################################
# StorageClass for EBS volumes
########################################
resource "kubernetes_storage_class" "ebs_gp3" {
  metadata {
    name = "ebs-gp3"
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }
}