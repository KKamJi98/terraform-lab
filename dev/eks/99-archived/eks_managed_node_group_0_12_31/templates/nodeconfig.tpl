MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthority: ${cluster_ca}
    cidr: ${cluster_cidr}
  kubelet:
    config:
      maxPods: 110
      clusterDNS:
      - ${cluster_dns}
    flags:
    - "--node-labels=node_group=${node_group}"
--//--