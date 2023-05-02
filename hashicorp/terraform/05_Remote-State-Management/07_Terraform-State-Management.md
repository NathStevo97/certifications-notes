# 5.7 - Terraform State Management

- It's good practice to use the `terraform state` command to make any state file modifications, rather than editing the state directly.
- State commands:

| State Command      | Description                                        |
| ------------------ | -------------------------------------------------- |
| `list`             | List resources in the state                        |
| `mv`               | Move an item in the state                          |
| `pull`             | Pull current state and output to a standard format |
| `push`             | Update a remote state from a local state file      |
| `replace-provider` | Replace a provider in the state                    |
| `rm`               | Remove instances from the state                    |
| `show`             | Show a resource in the state                       |

- The `mv` command is primarily used when you want to rename an existing resource without destroying and recreating it.
- The command will output a backup copy of the state prior to saving any changes.
- The mv command syntax generally follows:
  - `terraform state mv [options] /path/to/src`
  - `terraform state mv <name1> <name2>`

- The `pull` command is used to manually download and output the state from a remote state.
  - This is useful for reading values out of the state file and pairing it with other commands.

- The `push` command, though rarely used, can manually upload a local state file to a remote state.

- The `rm` command can be used to remove items from the state - this will not destroy the items, just stops Terraform from managing them.

- `show` shows all the attributes for all the resources. For a particular resource, use `terraform state show  <resource type>.<resource id>`
