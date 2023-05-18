# 3.0 - File Separation

Status: Done

# 3.1 - Intro to File Separation

## 3.1.1 - Host_Vars and Group_Vars

- Up until now, variables such as `ansible_ssh_pass` and `ansible_host` are all included in the same inventory file.
- This is not good practice for security purposes.
- What should be done is storing the variables under a separate YAML file under a new directory called `host_vars`.
    - The YAML file name should match up with the host defined in the inventory file.
- An example follows:

```
# Inventory

db_and_web_server
```

```yaml
# Sample variable file: host_vars/db_and_web_server.yaml

ansible_ssh_pass: <Password>
ansible_host: <host IP Address>
```

- When the Ansible playbook is triggered, it, by default, will look in this directory for the required YAML file.
- Similarly, `group_vars` should be used for group variables

## 3.1.2 - Include

- If you ever have a set of tasks that can be re-used, it’s often beneficial to split these sets of actions into tasks.
- In the case of the simple-webapp example, you could have:
    - Tasks to install the Database
    - Tasks to set up the web server
- Each of these should be stored under a `tasks` directory and named accordingly e.g. `deploy_db.yaml`
- These can then be referenced from the primary playbook in a similar manner to the following:

```yaml
- name: <Playbook Name>
  hosts: <hosts>
  tasks:
   - include: tasks/db_deploy.yaml
   - include: tasks/webapp_deploy.yaml
```