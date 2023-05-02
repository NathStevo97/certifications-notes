# 4.1 - DRY Principle

- Focused on the aspect of software engineering - **Don't Repeat Yourself**
- This aims to reduce the repetition of software patterns, such as defining functions for specific tasks where possible.
- This can also be applied to Terraform, one can define resources as modules to be called repeatably.

- Modules are typically defined in the following manner:

```go
module "<module name>" {
    source = "/path/to/module"

    input_var = <value>
    ....
    ....
}
```

- When Terraform is ran, it will check the defined source path to determine the configuration details.
