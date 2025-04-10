# 6.0 - Cleaning up Resources

- [6.0 - Cleaning up Resources](#60---cleaning-up-resources)
  - [Overview](#overview)

## Overview

- It's beyond recommended to cleanup cloud resources to avoid incurring charges for unused resources.

- Typically in this scenario, resources should be removed in the order of creation, each will require modules used to create them. Most of the time will be the same, with `state: absent` added instead of `present`
  - For any resources that need to be "found" before cleanup, modules of similar name with `_info` suffixed can be used e.g.:
    - `ec2_instance_info`
    - `ec2_vpc_net_info`
    - `ec2_vpc_route_info`

- Further information can be found via the Ansible docs.
- Example EC2 termination playbook:

```yaml
- name: AWS EC2 Termination
  hosts: localhost
  gather_facts: false

  vars_files:
  - vars/info.yaml
  - vars/instance_ids.yaml

  tasks:
  - name: Terminate Instances
    hosts: localhost
    connection: local
    tasks:
    - name: Terminate instances that were previously launched
      ec2:
        state: 'absent'
        instance_ids: '{{ instance_ids }}'
```
