# 05.1 - Ansible Playbooks

- [05.1 - Ansible Playbooks](#051---ansible-playbooks)
  - [Notes](#notes)

## Notes

- Playbooks are configuration files used to help Ansible understand what it needs to do when running.
- Example - Running commands on particular servers in a particular order, then restarting said servers in a particular order.
- Or more complex operations e.g.:
  - Deploy x VMs to environment 1
  - Deploy y VMS to environment 2
  - Provision storage to all VMs
  - Setup Network Configuration for all VMs in environment 2
- All Playbooks are written in YAML
  - They contain "plays" - a set of activities (tasks) to be run on hosts
  - Task - any action to be executed on the host e.g. run a script, install a package.
- Example Playbook:

```yaml
- name: Play 1
  hosts: localhost
  tasks:
  - name: Execute command "date"
    command: date

  - name: Execute script on server
    script: test_script.sh

  - name: Install httpd service
    yum:
      name: httpd
      status: present

  - name: start web server
    service:
      name: httpd
      state: started
```

- Each activity will occur in the order that they are defined on the host defined
  - The host must be included in the associated ansible inventory file e.g. localhost, server1.company.com
  - All connection information must be specified in the inventory files
  - Additionally, if a group is defined as the host, then all hosts in that group will be applied by default
- Playbooks = list of dictionary in YAML
  - Each play is a dictionary
  - Tasks are lists / arrays → ordered collection, meaning the order MATTERS
- The actions ran by tasks are modules e.g. command, script, yum, service
  - Further information provided in the ansible docs OR

    ```yaml
    ansible-doc -l
    ```

---

- To execute an ansible playbook:

```yaml
ansible-playbook <playbook>.yaml
```
