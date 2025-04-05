##########################################################
## AMIs
##########################################################
data "aws_ssm_parameter" "ubuntu_24_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_ssm_parameter" "ubuntu_24_04_ami_arm64" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}
