###############################################################
# Instance
###############################################################

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  host_id       = var.host_id

  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = var.vpc_security_group_ids

  user_data              = var.user_data
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}