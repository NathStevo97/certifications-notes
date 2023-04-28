# 2.14 - Validate Config Files

- Prior to running `terraform plan`, it's important to ensure configuration files are syntactically correct.

- Otherwise, when `plan` and `apply` are ran, errors may occur which can derail things.

- To validate, run `terraform validate`

- This checks the syntax for the configuration files ensuring there are no incorrect attributes, all variables are declared, etc.
