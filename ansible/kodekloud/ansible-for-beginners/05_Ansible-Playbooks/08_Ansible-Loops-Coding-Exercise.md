# 09.2 - Coding Exercise: Ansible Loops

- [09.2 - Coding Exercise: Ansible Loops](#092---coding-exercise-ansible-loops)
  - [Q1](#q1)
  - [Q2](#q2)

## Q1

The playbook currently runs an echo command to print a fruit name. Apply a loop directive (with_items) to the task to print all fruits defined in the `fruits`
 variable.

```yaml
-
    name: 'Print list of fruits'
    hosts: localhost
    vars:
        fruits:
            - Apple
            - Banana
            - Grapes
            - Orange
    tasks:
        -
            command: 'echo "{{item}}"'
            with_items: '{{fruits}}'
```

## Q2

To a more realistic use case. We are attempting to install multiple packages using yum module.The current playbook installs only a single package.

```yaml
-
    name: 'Install required packages'
    hosts: localhost
    vars:
        packages:
            - httpd
            - binutils
            - glibc
            - ksh
            - libaio
            - libXext
            - gcc
            - make
            - sysstat
            - unixODBC
            - mongodb
            - nodejs
            - grunt
    tasks:
        -
            yum: 'name={{item}} state=present'
            with_items: '{{packages}}'
```
