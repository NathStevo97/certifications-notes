# 7.0 - Error Handling

Status: Done

# 7.1 - Introduction

- As discussed in strategy, Ansible will execute each task sequentially until completion
- In the event of failure, the playbook will fail
- For multiple servers, if one task fails but runs fine on others, you do not want the entire playbook to stop, you should allow the others to continue for as long as possible.
    - This is default behaviour.
    - If wanting to change, add `any_errors_fatal: true` at the beginning of the playbook.

---

# Ignore Errors, Failed_When

- If there’s any tasks you’re not concerned about throwing errors, add to a task: `ignore_errors: yes`
- If there’s any tasks with specific fail conditions, add similar to:
`failed_when: “<Error Condition>”`  - this requires a `register:` usage
- Example:

```yaml
- command: cat /var/log/server.log
  register: command_output
  failed_when: "'ERROR' in command_output.stdout"
```