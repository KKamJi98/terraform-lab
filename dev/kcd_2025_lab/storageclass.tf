resource "kubernetes_storage_class_v1" "gp3_east" {
  provider = kubernetes.east

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type       = "gp3"
    fsType     = "ext4"
    encrypted  = "true"
  }

  mount_options = ["discard"]

  depends_on = [
    module.eks_east
  ]
}

resource "kubernetes_storage_class_v1" "gp3_west" {
  provider = kubernetes.west

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type       = "gp3"
    fsType     = "ext4"
    encrypted  = "true"
  }

  mount_options = ["discard"]

  depends_on = [
    module.eks_west
  ]
}
