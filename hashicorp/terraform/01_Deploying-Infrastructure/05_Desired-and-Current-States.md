# 1.5 - Desired and Current States

## 1.5.1 - Desired State

- The state defined within a configuration resource block e.g. in an `aws_instance` resource, if `instance_type = t2.micro`, that is reflective of the desired state - you desire an aws_instance of size `t2.micro` to be created.

## 1.5.2 - Current State

- State defined within the `terraform.tfstate` file.
- Holds configuration data regarding the resources created by Terraform.
- Used as the comparison point to determine any changes that need to be applied during `terraform apply` command execution.

## 1.5.3 - Updating Current State

- The current state can be updated by running `terraform refresh`
- The current state is always refreshed during a `plan` or `apply` command execution
- Terraform will always apply changes to ensure that the current state matches that of the desired state.
