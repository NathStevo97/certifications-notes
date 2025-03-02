#configure resource to be created
resource "aws_instance" "myec2" {
  ami           = "ami-0a13d44dccf1f5cf6"
  instance_type = "t2.micro"
  key_name      = "remote-exec-keypair"
  #configure provisioner with inline commands
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12", #install nginx
      "sudo systemctl start nginx"                     # start nginx
    ]
    connection {
      #connection method
      type = "ssh"
      user = "ec2-user"
      #private key for authentication
      private_key = file("./remote-exec-keypair.pem")
      host        = self.public_ip
    }
  }
}