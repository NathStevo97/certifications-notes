# 6.2 - Provider Use-Case: Multiple Regions

- Deploying to multiple regions can often be a challenge, as it may require multiple sets of authentication keys and regions.
- Using AWS as an example, if the `region` parameter is removed from `providers.tf`, then users will be asked to enter it and runtime.
- To support multi-region deployment, *provider aliases* can be utilised. This is essentially adding an ID to each instance of a provider.

- Example usage:

```go
provider "aws" {
    region = "us-west-1"
}

provider "aws" {
    alias = "aws02"
    region = "ap-south-1"
    profile = "account02" 
}
```

- If one was to deploy resources to the region of ap-south-1 rather than the default us-west-1, one can specify the provider to be used via the alias.
- Usage example: `provider = <provider_type>.<provider_alias>`
- Example from above: `provider = aws.aws02`