# 05.2 - Demo: Run Ansible Playbooks

## Notes

---

- When running ansible playbooks, generally have two options:
  - using the ansible command
  - using the ansible-playbook command
- The former is typically used in an imperative manner for one-off commands not requiring a playbook e.g.:

    ```yaml
    ansible <hosts> -a <command>

    ansible all -a "/sbin/reboot"

    ansible <hosts> -m <module>

    ansible target1 -m ping
    ```

- The latter should be used when wanting to run a particular playbook. This is in a declarative manner.

```yaml
ansible-playbook <playbook name>
```

---

## Demo

- In the demo project folder created previously, run the following:

```yaml
ansible all -m ping -i inventory.txt
```

- This will tell ansible to call the ping module to test connection
- Note: The all group is not specified in the inventory file, however it is created by default via ansible when specifying a particular inventory file.
- The same result could be achieved by a yaml file

```yaml
- name: Test Connectivity to Target Servers # name of playbook
  hosts: all # what hosts should this playbook apply to?
  tasks:
  - name: Ping Test
    ping: # note the ping module doesn't require any parameters
```

- This can then be ran by the following:

```bash
ansible-playbook playbook-pingtest.yaml -i inventory.txt
```

---

## Labs

### Q1

Update name of the play to `Execute a date command on localhost`

```yaml
-
    name: 'Execute a date command on localhost'
    hosts: localhost
    tasks:
        -
            name: 'Execute a date command'
            command: date
```

### Q2

Update the task to execute the command `cat /etc/hosts`
 and change task name to `Execute a command to display hosts file`

```yaml
-
    name: 'Execute a command to display hosts file on localhost'
    hosts: localhost
    tasks:
        -
            name: 'Execute a command to display hosts file'
            command: cat /etc/hosts
```

### Q3

Update the playbook to add a second task. The new task must execute the command `cat /etc/hosts`
 and change new task name to `Execute a command to display hosts file`

```yaml
-
    name: 'Execute two commands on localhost'
    hosts: localhost
    tasks:
        -
            name: 'Execute a date command'
            command: date
        - name: 'Execute a command to display hosts file'
          command: cat /etc/hosts
```

### Q4

We have been running all tasks on localhost. We would now like to run these tasks on the web_node1. Update the play to run the tasks on `web_node1`

```yaml
-
    name: 'Execute two commands on localhost'
    hosts: web_node1
    tasks:
        -
            name: 'Execute a date command'
            command: date
        -
            name: 'Execute a command to display hosts file'
            command: 'cat /etc/hosts'
```

### Q5

Refer to the attached inventory file. We would like to run the tasks defined in the play on all servers in `boston`

Inventory:

```shell
# Sample Inventory File

# Web Servers
sql_db1 ansible_host=sql01.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass
sql_db2 ansible_host=sql02.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass
web_node1 ansible_host=web01.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass
web_node2 ansible_host=web02.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass
web_node3 ansible_host=web03.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass

[db_nodes]
sql_db1
sql_db2

[web_nodes]
web_node1
web_node2
web_node3

[boston_nodes]
sql_db1
web_node1

[dallas_nodes]
sql_db2
web_node2
web_node3

[us_nodes:children]
boston_nodes
dallas_nodes
```

Answer:

```yaml
-
    name: 'Execute two commands on web_node1'
    hosts: boston_nodes
    tasks:
        -
            name: 'Execute a date command'
            command: date
        -
            name: 'Execute a command to display hosts file'
            command: 'cat /etc/hosts'
```

### Q6

Create a new play named `Execute a command to display hosts file contents on web_node2` to execute `cat /etc/hosts` command on second node `web_node2` and name the task `Execute a command to display hosts file`.

Refer to the attached inventory file (see Q5)

```yaml
-
    name: 'Execute command to display date on web_node1'
    hosts: web_node1
    tasks:
        -
            name: 'Execute a date command'
            command: date
-
    name: 'Execute a command to display hosts file contents on web_node2'
    hosts: web_node2
    tasks:
        -
            name: 'Execute a command to display hosts file'
            command: cat /etc/hosts
```

### Q7

You are assigned a task to restart a number of servers in a particular sequence. The sequence and the commands to be used are given below. Note that the commands should be run on respective servers only. Refer to the inventory file and update the playbook to create the below sequence.

> Note: Use the description below to name the plays and tasks.
>
1. `Stop` the `web` services on web server nodes - `service httpd stop`
2. `Shutdown` the `database` services on db server nodes - `service mysql stop`
3. `Restart` `all` servers (web and db) at once - `/sbin/shutdown -r`
4. `Start` the `database` services on db server nodes - `service mysql start`
5. `Start` the `web` services on web server nodes - `service httpd start`

> Warning: Do not use this playbook in a real setup. There are better ways to do these actions. This is only for simple practise.
>

Inventory:

```yaml
# Sample Inventory File

# Web Servers
sql_db1 ansible_host=sql01.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass
sql_db2 ansible_host=sql02.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass
web_node1 ansible_host=web01.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass
web_node2 ansible_host=web02.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass
web_node3 ansible_host=web03.xyz.com ansible_connection=ssh ansible_user=administrator ansible_ssh_pass=Win$Pass

[db_nodes]
sql_db1
sql_db2

[web_nodes]
web_node1
web_node2
web_node3

[all_nodes:children]
db_nodes
web_nodes
```

Answer:

```yaml
-
    name: 'Stop the web services on web server nodes'
    hosts: web_nodes
    tasks:
        -
            name: 'Stop the web services on web server nodes'
            command: 'service httpd stop'
-
    name: 'Shutdown the database services on db server nodes'
    hosts: db_nodes
    tasks:
        -
            name: 'Shutdown the database services on db server nodes'
            command: 'service mysql stop'
-
    name: 'Restart all servers (web and db) at once'
    hosts: all_nodes
    tasks:
        -
            name: 'Restart all servers (web and db) at once'
            command: '/sbin/shutdown -r'
-
    name: 'Start the database services on db server nodes'
    hosts: db_nodes
    tasks:
        -
            name: 'Start the database services on db server nodes'
            command: 'service mysql start'
-
    name: 'Start the web services on web server nodes'
    hosts: web_nodes
    tasks:
        -
            name: 'Start the web services on web server nodes'
            command: 'service httpd start'
```
