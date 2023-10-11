# 2.9 - Local Values

- A local value assigns a a name to an expression, allowing it to be used multiple times within a module without repeating it.

- To define local tags, add `locals {}` and then the desired values in the required format.
- Locals can be categorized and referenced accordingly e.g. `development = {}`, `production = {}`
  - To reference a category, add `local.<category_name>.<category value`
- An example follows:

```go
locals {
    common_tags {
        Owner = "DevOps Team"
        service = "backend
    }
}
```

- A common example for using locals is for non-sensitive defaults and conditionals, like resource name prefixes:
  - `name_prefix = var.name !="" ? var.name : local.name`

- The above example defines a naming convention. If `var.name` is blank, then the prefix defined in `local.name` is used.

- Locals can be helpful to avoid repeating the same values or expressions multiple times.

- They should be used in moderation, as they can make a configuration hard to read by future users of the files, they should only be used in situations where a single value or result is used in many places and said value is likely to be changed.
