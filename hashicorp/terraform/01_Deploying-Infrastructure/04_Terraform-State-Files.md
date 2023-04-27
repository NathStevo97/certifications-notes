# 1.4 - Terraform State Files

- Terraform keeps track of the infrastructure being created in a state file
- Allows terraform to map real-world resources to existing configurations
- Includes resource details including instance ID, IP addresses, tags,  etc.
- Therefore, when `terraform destroy` is ran against a a particular target, all the details relating to that resource will be removed from the state file
- State file is always named `terraform.tfstate`
- If changes made outside the terraform configuration files, when terraform apply is ran again, the tfstate file will be checked to make sure that the real world configuration is set up correctly, if not it will attempt to apply the appropriate changes to return/update to the desired state.
  - This may not work OR it may require recreation of resources (if the affected resource(s) have any dependencies)
