#AWS Provider Configuration
provider "aws" {
  region     = "eu-west-2"
}

#Resource 1 Configuration (Instance 1)
#resource "aws_instance" "instance-1" {
    #key_name = "machine_instance.${count.index}"
    #ami           = "ami-0a13d44dccf1f5cf6"
    #instance_type = "t2.micro"
    #count = 3
#}

##Resource 2 Configuration (Instance 2)
#resource "aws_instance" "instance-2" {
#    ami           = "ami-0a13d44dccf1f5cf6"
#    instance_type = "t2.micro"
#}

variable "elb_names" {
  type = list
  default = ["dev-loadbalancer", "stage-loadbalanacer","prod-loadbalancer"]
}

resource "aws_iam_user" "lb" {
  name = var.elb_names[count.index]
  count = 3
  path = "/system/"
}