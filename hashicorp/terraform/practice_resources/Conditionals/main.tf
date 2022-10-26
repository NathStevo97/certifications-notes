#AWS Provider Configuration
provider "aws" {
  region     = "eu-west-2"
}

#Define conditional variable to be checked
variable "istest" {}

resource "aws_instance" "dev" {
   ami = "0a13d44dccf1f5cf6"
   instance_type = "t2.micro"
   #If variable is true, 3 dev machines created, none if false
   count = var.istest == true ? 3 : 0
}

resource "aws_instance" "prod" {
   ami = "0a13d44dccf1f5cf6"
   instance_type = "t2.large"
   #If variable is false, 1 production machine created, none if true
   count = var.istest == false ? 1 : 0
}