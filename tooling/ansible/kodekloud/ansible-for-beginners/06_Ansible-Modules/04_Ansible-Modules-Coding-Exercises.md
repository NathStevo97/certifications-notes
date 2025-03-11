# 06.2 - Ansible Modules Coding Exercises

- [06.2 - Ansible Modules Coding Exercises](#062---ansible-modules-coding-exercises)
  - [Notes](#notes)
    - [Q1](#q1)
    - [Q2](#q2)
  - [Q3](#q3)
  - [Q4](#q4)

## Notes

### Q1

Update the playbook with a play to `Execute a script on all web server nodes`. The script is located at `/tmp/install_script.sh`

Use the [Script module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/script_module.html)

```yaml
- name: 'Execute a script on all web server nodes'
  hosts: web_nodes
  tasks:
  - name: 'Execute a script on all web server nodes'
    script: /tmp/install_script.sh
```

### Q2

Update the playbook to add a new task to `start httpd services` on all web nodes

Use the [Service module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)

```yaml
-
    name: 'Execute a script on all web server nodes'
    hosts: web_nodes
    tasks:
        -
            name: 'Execute a script on all web server nodes'
            script: /tmp/install_script.sh
        - name: 'start http services on all web server nodes'
          service:
            name: httpd
            state: started
```

## Q3

Update the playbook to add a new task in the beginning to add an entry into `/etc/resolv.conf` file for hosts. The line to be added is `nameserver 10.1.250.10`

> Note: The new task must be executed first, so place it accordingly.
>

Use the [Lineinfile module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)

```yaml
-
    name: 'Execute a script on all web server nodes'
    hosts: web_nodes
    tasks:
        - name: 'Add enntry to /etc/resolv.conf file'
          lineinfile:
            path: /etc/resolv.conf
            line: 'nameserver 10.1.250.10'
        -
            name: 'Execute a script'
            script: /tmp/install_script.sh
        -
            name: 'Start httpd service'
            service:
                name: httpd
                state: present
```

## Q4

Update the playbook to add a new task at second position (right after adding entry to resolv.conf) to create a new web user.

Use the [user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html) for this. User details to be used are given below:**Username**: web_user**uid**: 1040**group**: developers

```yaml
-
    name: 'Execute a script on all web server nodes and start httpd service'
    hosts: web_nodes
    tasks:
        -
            name: 'Update entry into /etc/resolv.conf'
            lineinfile:
                path: /etc/resolv.conf
                line: 'nameserver 10.1.250.10'
        - name: 'add user web_user'
          user:
            name: web_user
            uid: 1040
            group: developers

        -   name: 'Execute a script'
            script: /tmp/install_script.sh
        -
            name: 'Start httpd service'
            service:
                name: httpd
                state: present
```
