#AWS Provider Configuration
provider "aws" {
  region     = "eu-west-2"
  }

  locals {
  common_tags = {
    Owner = "DevOps Team"
    service = "backend"
  }
}
resource "aws_instance" "app-dev" {
   ami = "ami-0a13d44dccf1f5cf6"
   instance_type = "t2.micro"
   tags = local.common_tags
}

resource "aws_instance" "db-dev" {
   ami = "ami-0a13d44dccf1f5cf6"
   instance_type = "t2.small"
   tags = local.common_tags
}

resource "aws_ebs_volume" "db_ebs" {
  availability_zone = "eu-west-2"
  size              = 8
  tags = local.common_tags
}