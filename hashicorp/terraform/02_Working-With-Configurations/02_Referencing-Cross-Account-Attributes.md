# 2.2 - Referencing Cross-Account Resource Attributes

- As suggested previously, when creating resources, one should be able to use attributes and outputs to allow automatic configuration
- Examples follow:
    - Creating an Elastic IP and assigning it to an AWS EC2 Instance.
    - Creating an Elastic IP and assignign it to a Security Group for whitelisting

## 2.2.1 - EIP Association to EC2 Instance

- Associating an EIP with the EC2 instance, one requires an `aws_eip_association` resource, which will specify the following values based on other attributes:
- `instance_id = aws_instance.instance.id`
- `allocation_id = aws_eip_eip.id`

## 2.2.2 - EIP Association with Security Group

- Defining the security group should follow a format similar to:

```go
resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.main.id
    ingress {
        description = "TLS from VPC"
        from_port = 443
        to_port = 443
        8
        protocol = "tcp"
        cidr_blocks = [aws_vpc.main.cidr_block]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_tls"
    }
}
```