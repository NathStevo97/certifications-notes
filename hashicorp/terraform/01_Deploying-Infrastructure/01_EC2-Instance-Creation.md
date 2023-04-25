# 3.1 - EC2 Instance Creation

- Terraform supports a significant number of providers, this becomes an important consideration for organisations when working with terraform.
- In the case of AWS, can make use of any of the following:
    - Static credentials
    - Environment variableS
    - Shared credentials files
    - EC2 Roles
- For this demo, using static credentials:
    - AWS Console -> IAM -> Create User -> Allow programmatic access -> create user -> access and secret keys shown
- Add following to first_ec2.tf file:

```go

provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "myec2" {
    ami = "ami-<ami id>"
    instance_type = "t2.micro
}
```

- The above code first configures the provider, aws, providing the region
location for the vm deployment, along with the access and secret keys

- The code then looks to create an aws resource, in this case an ec2 instance of
a particular ami and instance type:
    - Instance type specifies parameters such as memory and cpu
- Note: ami and instance_type are the only two required parameters for a aws_instance resource, there are optionals available
- To initialize: terraform init
    - Terraform initialises the current directory, downloading additional
plugins required; which vary for each provider
- To validate the syntax used in config files: `terraform validate`
- To format: `terraform fmt`
- To plan the execution of the configuration: `terraform plan`
- To apply: `terraform apply`
- To destroy: `terraform destroy`