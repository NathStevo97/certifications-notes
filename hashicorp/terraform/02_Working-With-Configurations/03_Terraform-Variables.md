# 2.3 - Terraform Variables

- When working with Terraform. there's a significant chance there will be multiple static values in the project e.g. ami, ports, commands.
- Changing these values can become tedious to alter if used multiple times.
- To avoid this, it's advised to utilise variables.
- Typically variables are supplied from a file `variables.tf` in a centralised location, stored in the format:

```go
variable "<variable id>" {
    default = "<value default>"
    type = <type>
    description = "<variable description>"
}
```

- To reference a variable in a configuration, add `var.<variable_id>` where appropriate.
- Depending on the type of the variable, to adhere to data types, you may need to include it within parentheses e.g. []

- Once done, when `terraform apply` is ran, the variables stored in `variables.tf` are referenced.
- This massively simplifies things in production for variable values subject to change, such as IP addresses.