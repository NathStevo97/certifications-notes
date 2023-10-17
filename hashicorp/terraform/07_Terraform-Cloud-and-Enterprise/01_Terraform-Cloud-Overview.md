# 7.1 - Terraform Cloud Overview

- Terraform Cloud manages Terraform runs in a consistent and reliable environment. It provides various features such as:
  - Access controls
  - Private registry for module sharing
  - Policy controls

- Terraform Cloud projects are stored in workspace repositories
- Within these workspace repositories, information detailing the project can be found alongside additional info regarding Terraform runs, such as:
  - Plan details
  - Monthly cost estimates
  - `terraform apply` details.

- In some cases, policy checks may be present, this is essentially to verify any tags associated with resources.
- Users are allowed to comment on runs to keep track of progress and provide updates when necessary.

- Environment variables can be set within Terraform Cloud, and the TFstate file can be viewed.

- Terraform cloud can also be linked to Github repositories for projects, so when any changes are made, they are automatically applied to the workspace repository.
