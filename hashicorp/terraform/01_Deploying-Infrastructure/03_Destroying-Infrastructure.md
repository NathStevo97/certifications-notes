#  1.3 - Destroying Infrastructure

- Obviously we don't want to keep infrastructure running forever and racking up charges
- To bring down infrastructure, can run the command `terraform destroy`
- If you wish to destroy a specific target, add the -target flag in the format:
    `Terraform destroy -target <resource_type>.<resource_name>`
    e.g. `terraform destroy -target aws_instance.ec2`

- Alternatively could comment out the resource you don't wish to be applied or destroyed, though this is not recommended in general practice

**Note:** to automatically destroy: `terraform destroy --auto-approve`
