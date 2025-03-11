#Initialise resource

#Include provisioner to run commands to install nginx server
resource "aws_instance" "myec2" {
  ami           = "ami-0a13d44dccf1f5cf6"
  instance_type = "t2.micro"
  key_name      = "first-key-pair"

  #define provisioner to run commands upon machine creation
  provisioner "remote-exec" {
     inline = [
       "sudo amazon-linux-extras install -y nginx1.12",
       "sudo systemctl start nginx"
     ]

   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./first-key-pair.pem")
     host = self.public_ip
   }
   }
}