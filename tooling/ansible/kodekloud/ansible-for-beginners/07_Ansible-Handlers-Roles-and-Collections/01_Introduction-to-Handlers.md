# 7.1 - Introduction to Handlers

- [7.1 - Introduction to Handlers](#71---introduction-to-handlers)
  - [Introduction](#introduction)

## Introduction

- In some cases, configuration applied by Ansible may not take effect until the target server or service is restarted.
- Typically, one would then have to manually restart the server or service, Ansible Handlers aim to support this.
- Handlers allow definition of an action to restart the service and associate it with the task that modifies the configuration file.
  - Creates a dependency between the task and handler, and eliminates the need for manual intervention.
- One can therefore view handlers as tasks triggered by events / notifications.
  - They are defined in playbooks and executed when notified by a task.
  - They manage actions based on system state or configuration changes.

- An example playbook follows, the copy task notifies the defined handler to restart the service.:

```yaml
- name: Deploy application
  hosts: application_servers
  tasks:
  - name: copy application code
    copy:
      src: app/code
      dest: /opt/application/
    notify: Restart Application Service

  handlers:
  - name: Restart Application Service
    service:
      name: application_service
      state: restarted
```

- This is beneficial as the copy module has no way of restarting the service, another task would have to be defined.
