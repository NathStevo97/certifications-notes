# 4.4 - Registering Variables and Varoiable Precedence

## Variable Precedence

- If variables are defined in multiple places, the order of priority they are registered is variable precedence.
- In practice, Ansible will first assign variables defined at the group level, any vars defined at host level will then be applied or overwrite values as appropriate.
  - Host variables therefore take precedence over group variables.
- Any variables defined at playbook level and then at CLI level take precedence.
- So, in order of precedence, Ansible applies variables in the following order:
  - Group Vars
  - Host Vars
  - Playbook Vars
  - CLI vars (via `--extra-vars` flag)
- Additional options are available, however the above are the 4 more common methods.

## Registering Vars

- You may wish to capture the output of a particular task and pass it in as a variable to a follow-on task. This can be achieved via the `register` parameter.

```yaml
- name: Check /etc/hosts file
  hosts: all
  tasks:
  - shell: cat/etc/hosts
    register: result # output of shell command stored as variable "result"
  - debug:
      var: result
```

- The output can be further queried for specific values as it is in `json` output.
- Example: `var: result.stdout`

- Any variable created via `register` is available for the rest of the playbook for that given host; it has the host scope.
- Note: To avoid using the debug module, append the `-v` flag to the desired `ansible-playbook` command.
