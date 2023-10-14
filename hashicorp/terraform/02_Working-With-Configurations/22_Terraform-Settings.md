# 2.22 - Terraform Settings

- The `terraform {}` block is used to configure the behavior of Terraform itself when acting upon the configuration defined.
- Common settings include:
  - `required_version` - string criteria to determine the minimum / acceptable versions of Terraform that can be used with the configuration
  - `required_providers {}` - Specifies all providers required by the current module, mapping each to a specific source and assigning version constraints.

- Example:

```go
terraform {
  required_Version = "> <major>.<minor>.<patch>"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
}

<AWS Provider configuration>
```