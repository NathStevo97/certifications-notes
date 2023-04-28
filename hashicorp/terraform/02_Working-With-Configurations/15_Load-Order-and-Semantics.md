# 4.15 - Load Order and Semantics

- Generally, Terraform will load all the configuration files within the specific directory in alphabetical order, so long as the files end in `.tf`.
- In general practice, code should be split into multiple files. For example, a file for providers, a file for all networking resources, etc.
  - This allows for easier management of infrastructure.
- **Note:** When adding 2 of the same resource, you must give different IDs after defining the resource type.
