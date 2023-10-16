#  4.3 - Variables and Terraform Modules

- A common challenge with infrastructure management is the need to build environments, such as dev, staging, and production, with generally similar setups, but with slightly different variables.
- Module variables cannot be overridden, if you wish to change the values of a property, you can create a variables.tf file to reference in the folder
- Now, if a value is hardcoded in the source module, the variable value can be overwrote by any configuration referencing said module.

```go
module "<module name>" {
    source = "/path/to/module"

    input_var = <value>
    ....
    ....
}
```
