#  1.6 - Challenges of Current State and Computed Values

- If not running Terraform in a system with a readily-available editor, one can run `terraform show` to view the state file contents.
- **Note:** Suppose a change is made outside the desired state that isn't defined as code e.g adding a security group, Terraform will not act to update the current state since it's not in the desired state.
  - One would have to use `terraform import` to achieve this.
