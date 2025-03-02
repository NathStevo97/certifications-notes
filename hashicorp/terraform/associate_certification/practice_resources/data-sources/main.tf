#This file exists to show how to utilise data sources to
#Sort out applicable amis

#AWS Provider Configuration
provider "aws" {
  region     = "eu-west-2"
}

#configure data source to search for most appropriate amis for
#specified region
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"] #searches for latest amz linux 2 ami
  }
}

resource "aws_instance" "instance-1" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
}