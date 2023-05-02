# 4.4 - Terraform Registry

- A repository of modules written by the Terraform community.
- Modules are typically developed by third parties, however some community-submitted providers are also available.
- Hashicorp review modules for verification, and verified modules are actively maintained to remain up to date with Terraform and the respective providers.
- In the Terraform registry, modules are typically supported with:
  - Usage examples
  - Documentation and Variable Usage Guidance
- Using a module from Terraform Registry is similar to a standard module stored locally, just reference the source appropriately and specify any other parameters required.
  - `terraform init` will then reference this configuration and pull down the required files.
