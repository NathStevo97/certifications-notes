# 2.4 - Variable Assignment

- Variables can be assigned via 4 main methods:
  - **Environment Variables:**
    - A fallback method in case the others do not work.
    - Terraform will search its own local environment to find an environment variable to apply.
    - Terraform environment variables are set by any environment variables prefixed with `TF_VAR_`.
    - Example: `export TF_VAR_<variable name> <variable value>`
  - **Command-line flags:**
    - Not recommended unless only altering 1 variable,
    - Used by appending a flag during `plan` or `apply` commands e.g.:
      - `terraform plan -var="variable_id=value"`
    - Usually used when wanting to quickly test the effects of a new variable.
  - **From a file:**
    - Recommended over command line flags
    - In a new file `terraform.tfvars`, one can specify each variable's value in the form `variable_id = <value>`
    - To reference this file, append `-var-file="filename.tfvars"` when running `plan` or `apply` commands.
    - This will overrule any defaults set in `variables.tf`
  - **Variable Defaults:**
    - Store variable values in `variables.tf` and specify default values, referencing via `var.variable_id`.

- If no additional variable values are specified, the value will be assumed to be the default value (specified in `variables.tf`)
- If no default is specified, the value will need to be entered during command execution.
- Any variables entered at CLI level will take precedence over defaults and environment variables.
