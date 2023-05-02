# 5.8 - Importing Existing Resources with Terraform Import

- If a resource has been created via manual methods, but you wish to manage it via Terraform, it must be imported.
- To import a resource, a  corresponding resource block with particular parameters must be defined.
  - This resource block is defined as normal, but must contain values specific to the resource e.g. name must be correct.

- To import, run `terraform import <resource type>.<resource_identifier>`

- This will look up the resource based on the provided configuration and save the mapping to the Terraform state.
  - This can be verified by `terraform state` commands.

- Once verified, any changes to the resource will now have to be made via Terraform.
