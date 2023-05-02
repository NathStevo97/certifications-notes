#  3.3 - Remote-Exec Implementation

- For remote-exec to run, the resource must be created first i.e. the provisioner must be added within a resource block.
- Requires 2 properties to be defined:
  - Inline: The commands to be ran
  - Connection: Connection parameters for the desired method.

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

- In the `inline` block, any commands to be run in the machine are added, separated by a comma - these must be syntactically correct.
- Under connection, specify the parameters required for the desired connection method e.g. for SSH, one needs the user, private key, and host IP.
