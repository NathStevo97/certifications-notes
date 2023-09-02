# 1.8 - Provider Versioning

- Providers are split into 2 categories:
  - Hashicorp-Distributed: Automatically downloaded during Terraform init
  - Third-party

- The need for third party providers arises whenever an official provider doesn't support a particular functionality, or when organizations have developed their own platform to run terraform on.

- Hashicorp distributed providers are listed under "Major Cloud Providers" under the HashiCorp website; third party providers are under the "Community" tab.

- When attempting to initialise with a third party provider, it's likely that an error will occur.
- As mentioned, terraform init cannot automatically install the plugins for third party providers, they must be installed manually.
- The installation can be achieved by placing the plugins into the system's user plugins directory (OS-dependent).

| OS                      | Directory                       |
| ----------------------- | ------------------------------- |
| Windows                 | `%APPDATA%\terraform.d\plugins` |
| Other (e.g. Linux, MAC) | `~/.terraform.d/plugins`        |
