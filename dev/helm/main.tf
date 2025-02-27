resource "helm_release" "nginx" {
  name       = "my-nginx"                                 # K8s 내 Release 이름
  repository = "oci://registry-1.docker.io/bitnamicharts" # 차트 레포지토리
  chart      = "nginx"                                    # 차트명
  version    = "18.3.6"                                   # 차트 버전 (원하는 버전)

  namespace        = "helm-provider-practice" # 배포할 네임스페이스
  create_namespace = true                     # 네임스페이스가 없을 경우 생성

  # values = [
  #   file("nginx-values.yaml")  # 차트 설정(Values) 파일을 넣을 수도 있음
  # ]

  # 단순 key-value 형식 설정 (set)
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "80"
  }

  set {
    name  = "replicaCount"
    value = "3"
  }

  # 예시) Atomic, Timeout 등 옵션 설정 가능
  atomic  = true
  timeout = 300
}
