# 4.5 - Terraform Workspace

- Workspace = Groupings of applications.
- Terraform allows the use of multiple workspaces. Each workspace can use a set of environment variables.
  - This is often useful for running multiple environments on the same machine.

- To utilize workspaces:

| Command                                       | Definition                                                                                   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `terraform workspace list`                    | List the existing workspaces <br> Current workspace denoted by *                             |
| `terraform workspace select <workspace_name>` | Switch to a pre-existing workspace                                                           |
| `terraform workspace new <workspace_name>`    | Create a new workspace (automatically switches)                                              |
| `terraform workspace delete <workspace_name>` | Delete a particular workspace <br> Use `-force` to force deletion if not an empty workspace. |
| `terraform workspace show`                    | Show current workspace details                                                               |
