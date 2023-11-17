# 4.7 - Ansible Facts

- Ansible gathers basic facts about the target machine upon initial connection, such as:
  - basic system information
  - system architecture
  - architecture
  - network connectivity
  - ip addresses
  - storage information
- Ansible gathers all these `facts` via the `setup` module, which is ran automatically at the start of each playbook, unless `gather_facts` is disabled.
- All facts gathered by ansible are stored in the `ansible_facts` variable. This can be viewed via the `debug` module, passing `ansible_facts` as the var.
- Gathering facts can be disabled at playbook level by setting `gather_facts: no`, or at config level by setting `gathering = implicit/explicit`
  - At config level, implicit will gather facts by default, unless specified not to at playbook level.
  - Explicit will not gather facts by default, unless specified otherwise at playbook level.
  - Playbook-level configuration always takes precedence.
- Fact-gathering only applies to hosts defined in inventory files.
