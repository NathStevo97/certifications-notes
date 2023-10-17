# 7.4 - Remote Backend

- The remote backend stores Terraform state files and may be used to run operations in the Terraform Cloud.
- TF Cloud may also be used with local operations, in which case, only the state is stored in the remote backend.

## 7.4.1 - Remote Operations

- When using full remote operations, commands like `terraform plan` can be executed in Terraform Cloud's runtime environment, with log output streamed to the local terminal.
- To configure the backend, the following must be applied to the Terraform configuration files

- In the file containing the resource(s), add a block containing `backend "remote" {}`
- In `backend.hcl` add the following:
  - `workspaces { name = "repository_name" }`
  - `hostname = "app.terraform.io"`
  - `organization = "organization_name"`

- Once setup, when Terraform plan or apply is ran, it will run the Terraform Cloud UI. The logs can then be viewed directly via this method.
- Additionally, cost estimations and Sentinel Policies will be checked if enabled.
- If resources are configured locally but remote operations are desired, a workspace with a VCS connection cannot be used.
