# 5.0 - Building Custom AMIs with Ansible

## Build AMIs

- To gather info around the AMI suitable for usage within the region and deployment, use the `ec2_ami_info` module.
  - This can filter by parameters such as:
    - region
    - owners
    - architectures

- Once the AMI is determined, the EC2 instance can be deployed via the ec2 module.

- The `ec2_ami` module can then register or deregister AMIs, this can be applied to a running EC2 instance.
- Example usage:

```yaml
- name: Create an AMI
  ec2_ami:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    instance_id: "{{ ec2info.instance_ids[0] }}"
    wait: yes
    name: "pluralsight-{{ uuid }}"
    tags:
      Name: "pluralsight-{{ uuid }}"
      Service: TestService
```

## Disclaimer

- Whilst this IS achievable via Ansible, it's recommended to use a tool specifically designed to create custom AMIs, such as Hashicorp Packer. Packer can then run ansible playbooks to do the configuration.