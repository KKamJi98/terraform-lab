terraform {
  backend "remote" {
    # hostname이 Terraform Cloud(TFC) 기본값은 app.terraform.io,
    # HCP Terraform은 별도 hostname을 제공할 수 있음
    hostname = "app.terraform.io"

    # HCP Terraform에서 설정한 Organization, Workspace 이름
    organization = "KKamJi"

    workspaces {
      # Workspace 선택
      name = "basic"
    }
  }
}