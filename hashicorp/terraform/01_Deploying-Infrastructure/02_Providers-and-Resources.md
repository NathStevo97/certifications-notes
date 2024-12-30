# 1.2 - Providers and Resources

- [1.2 - Providers and Resources](#12---providers-and-resources)
  - [Introduction](#introduction)
  - [Provider Maintainers](#provider-maintainers)
  - [Required Providers](#required-providers)

## Introduction

- Terraform is capable of supporting multiple providers
- The provider details the infrastructure is to be launched on must be specified in the configuration files
- In some/most cases, authentication tokens will also be required - these should never be included in source code, referenced instead via environment variables or another appropriate method.
- When the command `terraform init` is ran, terraform downloads plugins associated with the provider to the `.terraform` directory in the project root.
- Each provider has different resources that can be created, with each resource type specific to the particular provider e.g. for AWS:
  - `aws_instance` - Virtual Machine/Instance
  - `aws_alp` - Application load balancer
  - `iam_user` - Identification Application Managment User
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

## Provider Maintainers

- There are 3 main types of provider tiers in Terraform:
  - **Official** - Owned and maintained by HashiCorp
  - **Partner** - Owned and maintained by a direct partner of HashiCorp
  - **Community** - Owned and Maintained by Individual Contributors

## Required Providers

- For providers not directly maintained by HashiCorp, a `required_providers` block is required, taking DigitalOcean as an example, the configuration before would become:

```go
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean
    }
  }
}

provider "digitalocean" {
    token = "<TOKEN>"
}
```

- Details on how to reference each provider is typically provided in the provider's documentation.
