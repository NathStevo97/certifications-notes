# 2.11 - Data Sources

- Data sources allow data to be fetched or computed for use elsewhere within Terraform configuration.
- As an example, if an AWS EC2 Instance was to be configured, the desired AMI will differ depending on the region.
- Rather than manually hardocde the AMI, a data source can be used to filter the appropriate AMIs for a given region.
- Data source code is defined under a `data` block and reads from a specific data source, exporting it to the data block identifier.

- Example:

```go
data "aws_ami" "app_ami" {
    most_recent = true
    owners = ["amazon]
    filter {
        name = "name"
        values = ["amazn2-ami-hvm*"]
    }
}
```

- Now when `terraform plan` is applied, the data source block will automatically search for the latest iteration for the Amazon Linux 2 AMI for the chosen region. This can be altered for different owners, ami values, etc.
