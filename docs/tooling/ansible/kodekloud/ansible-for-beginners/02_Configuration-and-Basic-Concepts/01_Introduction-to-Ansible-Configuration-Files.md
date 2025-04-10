# 2.1 - Introduction to Ansible Configuration Files

- [2.1 - Introduction to Ansible Configuration Files](#21---introduction-to-ansible-configuration-files)
  - [Introduction](#introduction)

## Introduction

```shell
[defaults]

inventory = /path/to/inventory/file # e.g. /etc/ansible/hosts
log_path = /path/to/log/file # e.g. /var/log/ansible.log

library = /path/to/modules/folder # e.g. /usr/share/my_modules/
roles_path = /path/to/roles/folder # e.g. /etc/ansible/roles
actions_plugins = /path/to/action/plugin # e.g. /user/share/ansible/plugins/action

gathering = implicit # how ansible gathers facts

# SSH Timeout
timeout = 10
forks = 5 # how many hosts can ansible target at any given point

[inventory]

enable_plugins = plugin1, plugin2, plugin3, ...

[privilege_escalation]

[paramiko_connection]

[ssh_connection]

[persistent_connection]

[colors]

```

- Ansible will, unless specified otherwise, refer to this configuration when any playbook is ran on the control machine.
- This isn't mandatory, one can define specific configuration files for specific playbooks based on use cases, make a copy of the config file in the playbooks directory(ies), and make the changes accordingly.
  - Upon execution, any config file in the playbook's directory will take precedence over the default.
- If the config file is to be stored away from the playbook directory, add the environment variable `$ANSIBLE_CONFIG=/path/to/file` prior to any `ansible-playbook` command.

- In terms of precedence, config files specified by `$ANSIBLE_CONFIG` will take top priority, then any cfg in the playbook's directory, then `.ansible.cfg` in the user home directory, and finally `/etc/ansible/ansible.cfg`.
- **Note:** The cfg files outside of the default location do not have to have every single parameter defined, only the ones which you wish to override.

- In the event of only one or two variables needing to be overwritten, one could add `ANSIBLE_<CONFIG PARAMETER NAME>=value` prior to `ansible-playbook` execution.
  - This would take top priority, but does not persist command to command.
  - One could `export` the variable to persist in the shell.
  - To persist outright across shells, it's advised to create a new `ansible.cfg` file in the desired location.

- To understand the configurations available and default values, use `ansible-config list`.
- To view the current config file: `ansible-config view`
- To view the current settings and where the settings are set from e.g. environment variables: `ansible-config dump`
