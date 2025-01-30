terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# provider "helm" {
#   kubernetes {
#     host     = "https://cluster_endpoint:port"

#     client_certificate     = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0...")
#     client_key             = base64decode("LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVk...")
#     cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0...")
#   }
# }