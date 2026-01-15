#######################################
# Security Groups
#######################################

module "kkamji_security_group" {
  source      = "../../modules/security_group"
  name        = "kkamji-test-sg"
  description = "kkamji-test-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound ports"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#######################################
# EC2 Key Pair
#######################################

resource "aws_key_pair" "my_key" {
  key_name   = "kkamji_key_2024"
  public_key = var.public_key_string
  lifecycle {
    ignore_changes = [public_key]
  }
}

#######################################
# IAM
#######################################
resource "aws_iam_user" "external_secrets" {
  name = "external-secrets"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_user" "external_dns" {
  name = "external_dns"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_user_policy_attachment" "external_secrets_secrets_manager_policy" {
  user       = aws_iam_user.external_secrets.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_user_policy_attachment" "external_secrets_parameter_store_policy" {
  user       = aws_iam_user.external_secrets.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
