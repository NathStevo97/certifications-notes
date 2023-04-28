# 2.1 - Attributes and Output Values

- Terraform can output the values of certain attributes of a resource.
- Output attributes can be used for both user reference, as well as input variables for other resources to be created.
    - **Example:** When an elastic IP address is created, it should automatically be added to the security group for whitelisting.
- For an output, if you set a value as `<resource_type>.<resource_id>`, this will output all the attributes associated with that resource.
- For a particular outpit, append the attribute name to the above reference i.e. `<resource_type>.<resource_id>.<attribute_name>`.
    - Example: `aws_eip.lb.public_ip`

- **Note:** A list of attributes that can be output is generally listed with each resource in the Terraform documentation.

- In general:
    - Attribute: Reference of a value associated with a particular property of a resource
    - Outputs: Used to output the value of a particular attribute.