# 1.7 - Provider Versioning

- Terraform providers exist to provide a link between terraform and the service provider, allowing terraform to provision infrastructure to the appropriate provider.
- Plugins for the providers are released separately from Terraform and are updated in their own time.
- In terraform init, the latest provider plugin will automatically be downloaded if the version isn't specified.
  - In production, it's recommended to specify the version that you know the code works for e.g. AWS version 2.7.
- To specify the provider version, in the provider block of the configuration file, add `version = "version number"` as an exact number or express it as a criteria:

| Version Argument | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| >=x.y            | Greater than or equal to version value                         |
| <=x.y            | Less than or equal to version value                            |
| ~>x.y            | Any version in the subrange of value x i.e. any version of 2.y |
| >=a.b,<=c.d      | Any version between a.b and c.d                                |

- **Note:** Certain provider plugins aren't compatible with particular versions of Terraform - it will specify and suggest alternate versions if this occurs.
