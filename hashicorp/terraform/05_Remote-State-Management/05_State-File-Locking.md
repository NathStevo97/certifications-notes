#  5.5 - State File Locking

- During any operation that affects the state file, such as an `apply` command, the state file is locked by Terraform.
- This is hugely important as if someone edited the state file during application, the state will become corrupted.
- State file locking automatically occurs when working with Terraform in the CLI and state file if stored locally.
  - For remote backends, other methods are required for state locking.
