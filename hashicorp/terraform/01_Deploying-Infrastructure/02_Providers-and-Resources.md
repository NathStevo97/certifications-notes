# 1.2 - Providers and Resources

- Terraform is capable of supporting multiple providers
- The provider details the infrastructure is to be launched on must be specified in the
configuration files
- In some/most cases, authentication tokens will also be required
- When the command terraform init is ran, terraform downloads plugins associated
with the provider
- Each provider has different resources that can be created, with each resource type
specific to the particular provider e.g. for AWS:
  - Aws_instance - Virtual Machine/Instance
  - Aws_alp - Application load balancer
  - Iam_user - Identification Application Managment User
- The above resources couldn't be provisioned by e.g. Azure with this syntax, would have to use the provided syntax for Azure
- Consider the following example:

```go

provider "digitalocean" {
    token = "<TOKEN>"
}

resource "digitalocean_droplet" "droplet" {
    image = "image id"
    name = "web-1"
    region = "nyc1"
    size = "<size-identifier>"
}

```

- In terms of syntax, the general format is followed, defining a provider and configuring it, followed by a resource which is configured as desired.
  - Since this is for a different provider (DigitalOcean), the syntax for parameters such as the image or region names
  - In terms of authentication, only one token is required for provider configuration unlike AWS.
