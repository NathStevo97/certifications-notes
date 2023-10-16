#  4.6 - Implementing Terraform Workspace

- Considering a scenario for a set of workspaces, with a variable that's subject to change from workspace-to-workspace.
- Rather than having separate variables files, which would be hard to track and maintain, one can use a standalone variables file in a similar manner to the following:

```go
variable "instance_type" {
    type = "map"
    default = {
        workspace1 = value1
        workspace2 = value2
        workspace3 = value3
    }
}
```

- Using variables like this is achieved by: `lookup(var.<var name>, terraform.workspace)`

- Each workspace's state file is stored in a new folder, `terraform.tfstate.d`. The default workspace's state file remains in the standard location.
