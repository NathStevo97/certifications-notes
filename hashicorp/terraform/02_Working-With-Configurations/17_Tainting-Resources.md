# 2.17 - Tainting Resources

- Consider a scenario where a new resource has been created, but users have made a lot of manual changes to it in terms of both infrastructure and within the server.
- To deal with this, one can either import the changes to Terraform or delete and recreate the resource to update the configuration.
- The command `terraform taint` manually marks a resource as "tainted", forcing the resource to be destroyed and recreated during the next `terraform apply` execution.
- To taint, use the command similar to: `terraform taint <resource type>.<resource_id>`
