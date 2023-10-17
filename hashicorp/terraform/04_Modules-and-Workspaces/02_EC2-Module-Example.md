# 4.2 - Module Implementation: EC2 Instance

- Adopting the following Architecture:

- Root
  - Modules
  - Projects
    - A
    - B

- A sample EC2 Module can be created by adding the following to a file under `modules`

```go
resource "aws_instance" "myec2" {
  ami           = "ami-0a13d44dccf1f5cf6"
  instance_type = "t2.micro"
  key_name      = "remote-exec-keypair"
  #configure provisioner with inline commands
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12", #install nginx
      "sudo systemctl start nginx"
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
```

- This can then be referenced by any terraform files in the projects folder, which will pull all the required provider plugins alongside it.
- Using modules makes things significantly easier for management and readability, as all configuration is stored and therefore managed in 1 place.
  - Similarly, any users unfamiliar to Terraform will not be overwhelmed when using the module, as they would only need to reference the module and add any required input variables.
