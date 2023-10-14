# 2.23 - Challenges with Large Infrastructure

- When dealing with significantly large configurations, API limits for a provider may be incurred.
- This occurs as when Terraform plan runs, the state is refreshed for each resource defined - this can take significantly long for large amounts of infrastructure.
- To work around this, it's advised to break resources up into separate configuration files, this can be on per-resource type, per function, per component, etc.

- If still facing issues post-breaking configuration down, one can stop Terraform from querying the current state by adding the `-refresh=false` flag.
- Alternatively, Terraform commands can be used to target specific resources e.g. `-target=<resource type>.<resource name>` or `-target=<resource type>` for all instances of a particular resource.
  - This is **NOT** a recommended approach for production!
