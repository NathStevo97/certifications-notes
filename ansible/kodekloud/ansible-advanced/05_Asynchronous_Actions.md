# 5.0 - Asynchronous Actions

Status: Done

# 5.1 - Asynchronous Actions Introduction

- SSH connections stay alive for the duration of the playbook
- This is not good for when there are tasks we want to run post-playbook to check the result, this is typically admin tasks such as "check that the connection to the database"
- This is achieved by asynchronous playbooks.
- Suppose there is a script to run health checks against the app, this script may take up to 5 minutes, so we don't want to it have ansible's connection open for the duration.
- Introduce the `async` parameter to the designated task e.g.

```yaml
tasks:
- command: <path to script>
  async: 360 # maximum time expected for task to occur for (seconds)
  poll: 60 # in seconds, how often should ansible check on the result (10s = default)
```

- Use the `poll` value to specify in seconds how often ansible should check on the result of the task.
- This will kick off the task, wait for 6 minutes to allow the task to finish, and move on.
- For multiple async jobs, this could be time-consuming, especially if tasks can be ran in parallel; this can be done by setting `poll` to 0.
- It's best practice to register the result of the async action via `register: <result name>`
  - One can then add an additional task at the end to check the status of the asynchronous tasks before concluding the play:

```yaml
- name: Check status of tasks
  async_status: jid={{ async_task_result.ansible_job_id }}
  register: job_result
  until: job_result.finished
  retries: 30
```

- Note: not all modules support async - verify this with the ansible documentation before proceeding!
