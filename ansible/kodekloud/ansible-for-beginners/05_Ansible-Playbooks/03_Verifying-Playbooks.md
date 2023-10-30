# 5.3 - Verifying Playbooks

- It's highly important to verify playbooks prior to execution to try and catch unforseen issues and prevent service downtime.
- Playbook verification can be achieved via two main methods, `check mode` and `diff mode`

## Check Mode

- This is ansible's dry-run mechanism, that attempts to run the playbook without making any actual changes on the hosts.
- Achievable via appending the `--check` flag when executing an `ansible-playbook` command.
- *Not all modules support this option*

## Diff Mode

- When used in combination with check mode, provides a before-and after comparison of playbook tasks.
- This helps to understand and verify the impact of tasks pre-application.
- Add the `--diff` flag to the `ansible-playbook` command to use.

## Syntax Check

- Ansible has built-in syntax check mode, simply add the folliwing flag: `--syntax-check`
