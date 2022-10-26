# 07.2 - Coding Exercise: Ansible Variables

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Q1:

The playbook is used to update name server entry into resolv.conf file on localhost. The name server information is also updated in the inventory file as a variable `nameserver_ip`. Refer to the inventory file.

`Replace the ip of the name server in this playbook to use the value from the inventory file`, so that in the future if you had to make any changes you simply have to update the inventory file.

```yaml
 -
    name: 'Update nameserver entry into resolv.conf file on localhost'
    hosts: localhost
    tasks:
        -
            name: 'Update nameserver entry into resolv.conf file'
            lineinfile:
                path: /etc/resolv.conf
                line: 'nameserver {{ nameserver_ip }}'
```

# Q2:

We have added a new task to disable SNMP port in the playbook. However the port is hardcoded in the playbook. Update the inventory file to add a new variable `snmp_port` and assign the value used here. Then update the playbook to use value from the variable.

Remember to use curly braces around the variable name.

```yaml
-
    name: 'Update nameserver entry into resolv.conf file on localhost'
    hosts: localhost
    tasks:
        -
            name: 'Update nameserver entry into resolv.conf file'
            lineinfile:
                path: /etc/resolv.conf
                line: 'nameserver {{ nameserver_ip }}'
        -
            name: 'Disable SNMP Port'
            firewalld:
                port: '{{ snmp_port }}'
                permanent: true
                state: disabled
```

# Q3:

We are printing some personal information to the screen. We would like to move the `car_model`, `country_name` and `title` to a variable defined at the play level.

Create three new variables (`car_model`, `country_name` and `title`) under the play and move the values over. Use the variables in the task.

```yaml
-
    name: 'Update nameserver entry into resolv.conf file on localhost'
    hosts: localhost
    vars:
      car_model: BMW M3
      country_name: USA
      title: Systems Engineer
    tasks:
        -
            name: 'Print my car model'
            command: 'echo "My car''s model is {{ car_model }}"'
        -
            name: 'Print my country'
            command: 'echo "I live in the {{country_name}}"'
        -
            name: 'Print my title'
            command: 'echo "I work as a {{title}}"'
```