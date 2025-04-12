# 3.3 - Inventory Format

## Introduction

- Ansible inventory formats offer differ from scenario to scenario.
- For small-scale projects, simpler formats are likely required as only a small number of servers are used.
- For large-scale projects, there are likely resources spread worldwide carrying out a multitude of functions.

- Small projects therefore could get away with simple `.ini` formats, whilst a `yaml`-based inventory would be suitable for large-scale projects.

## Ini Format

- The most simple and straightforward format.

```shell
[webservers]
web1.example.com
web2.example.com

[dbservers]
db1.example.com
db2.example.com
```

- Servers are grouped under `[]`

## YAML Format

- More structured than the `.ini` format. An example follows:

```yaml
all:
  children:
    webservers:
      hosts:
        web1.example.com
        web2.example.com
    dbservers:
      hosts:
        db1.example.com
        db2.example.com
```

- Inventory format should be chosen based on project needs.
