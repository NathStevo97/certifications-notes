# 3.1 - Introduction to Provisioners

- Provisioners are used to execute scripts or commands locally or on a remote instance during resource creation. A classic example is installing NGINX on a web-server.

```go
provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras install -y nginx1.12",
        "sudo systenmctl start nginx"
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("~/path/to/key")
        host = self.public_ip
    }
}
```

- When defining the `remote-exec` provisioner, one must define the inline commands to be run as well as the method of connection (with associated parameters).