data "terraform_remote_state" "basic" {
  backend = "remote"
  config = {
    organization = "KKamJi"
    workspaces = {
      name = "basic"
    }
  }
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}