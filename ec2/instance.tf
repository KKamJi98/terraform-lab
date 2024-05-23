provider "aws" {
    region = "ap-northeast-2"
}

data "aws_ssm_parameter" "access_key" {
    name            = "/kkamji/aws_access_key"
    with_decryption = true
}

data "aws_ssm_parameter" "secret_key" {
    name            = "/kkamji/aws_secret_key"
    with_decryption = true
}

provider "aws" {
    alias       = "secure"
    region      = "ap-northeast-2"
    access_key  = data.aws_ssm_parameter.access_key.value
    secret_key  = data.aws_ssm_parameter.secret_key.value
}

resource "aws_vpc" "example_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "example_vpc"
    }
}

resource "aws_subnet" "example_subnet" {
    vpc_id     = aws_vpc.example_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "example_subnet"
    }
}

resource "aws_instance" "example" {
    provider      = aws.secure
    ami           = "ami-0e6f2b2fa0ca704d0"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.example_subnet.id

    tags = {
        Name = "example_instance"
    }
}