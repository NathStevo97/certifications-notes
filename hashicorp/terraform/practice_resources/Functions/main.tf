#This file exists to create a simple ec2 instance along with a key pair for login access

#AWS Provider Configuration
provider "aws" {
  region     = "eu-west-2"
}
#use date format function to automatically format date and time UTC format
locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

#Define default region file
variable "region" {
  default = "eu-west-2"
}
#Define instance names/tags
variable "tags" {
  type = list
  default = ["firstec2","secondec2"]
}
#define ec2 amis to be used depending on region
variable "ami" {
  type = map
  default = {
    "eu-west-2" = "ami-03baa6e330bed0b71" #Ubuntu Server 16.04 LTS AMI
    "us-west-2" = "ami-0d6621c01e8c2de2c"
    "ap-south-1" = "ami-0470e33cd681b2476"
  }
}

#provision aws key pair for login access (generate key by ssh-keygen -o)
#key saved to path below
resource "aws_key_pair" "loginkey" {
  key_name   = "login-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#provision aws instance to be created
resource "aws_instance" "app-dev" {
    #lookup retrieves the value of a single element from a map, given its key
    #lookup(map, key, default)
   ami = lookup(var.ami,var.region) #looks in region list for value and finds corresponding value in ami map
   instance_type = "t2.micro"
   key_name = aws_key_pair.loginkey.key_name
   count = 2

   tags = {
     Name = element(var.tags,count.index) #assigns tag depending on instance name
   }
}


output "timestamp" {
  value = local.time
}