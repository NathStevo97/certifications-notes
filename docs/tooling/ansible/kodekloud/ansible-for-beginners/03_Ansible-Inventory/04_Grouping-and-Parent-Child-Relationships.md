# 3.4 - Grouping and Parent-Child Relationshops

## Introduction

- It's important to utilise grouping in inventory files for ease of life and reduction of human error.
- Typically, servers are grouped based on aspects such as location and functionality.
- In the event of sub-grouping, parent-child relationships can be utilised in Ansible.
- For example web servers could act as one group, which could be further split into subgroups based on locations.

## Ini Format

- Subgroups are defined by being listed under `[<group name>:children]`

```shell
[webservers:children]
webservers_us
webservers_eu

[webservers_us]
web1_us.example.com
web2_us.example.com

[webservers_eu]
web1_eu.example.com
web2_eu.example.com
```

## YAML Format

```yaml
all:
  children:
    webservers:
      children:
        webservers_us:
          hosts:
            web1_us.example.com:
              ansible_host: <ip address>
            web2_us.example.com:
              ansible_host: <ip address>
        webservers_eu:
          hosts:
            web1_eu.example.com:
              ansible_host: <ip address>
            web2_eu.example.com:
              ansible_host: <ip address>
```
