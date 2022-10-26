#Configure provider and apply authentication values
provider "aws" {
  region     = "eu-west-2"
}

#configure resource to be created
resource "aws_instance" "myec2" {
  ami           = "ami-0a13d44dccf1f5cf6"
  instance_type = "t2.micro"
}

#Configure Elastic IP
resource "aws_eip" "lb" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
    instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

resource "aws_security_group" "allow_tls" {
  name        = "first-security-group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"] #specify public IP to be associated
                                                #ensure the referenced attribute is in "${}"

#    cidr_blocks = [aws_eip.lb.public_ip/32]
  }
}