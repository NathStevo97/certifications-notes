#Configure provider and apply authentication values
provider "aws" {
  region     = "eu-west-2"
}

#configure resource to be created
resource "aws_instance" "myec2" {
  ami           = "ami-0a13d44dccf1f5cf6"
  instance_type = "t2.micro"
}
