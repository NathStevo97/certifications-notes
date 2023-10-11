# 2.8 - Conditional Expressions

- Expressions that use booleans to select one of two values, true or false.
- Defined in Terraform in a similar manner to `condition ? true_val : false_val`

- Example: Suppose there are a set of resources that should only be created if a particular variable is set e.g. `use_dev_env = true`

- For each resource, add an attribute property followed by the condition:
    `attribute = var.<variable name> == true ? <true value> : false value`

- In the other dependent variable:
    `attribute = var.<variable name> == false ? <true_value> : <false_value>`

- The boolean variable is defined with a default value in `terraform.tfvars` and `variables.tf`
