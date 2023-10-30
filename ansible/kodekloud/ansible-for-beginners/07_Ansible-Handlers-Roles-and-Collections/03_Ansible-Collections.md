# 7.3 - Ansible Collections

- In the scenario that a large amount of multiple types of network devices are being managed, whilst Ansible provides some built-in modules, specialised modules and plugins can be accessed via collections.
- Collections are typically defined by `<collection name>.<sub collection>`
- Installation of collections is via `ansible-galaxy` i.e.: `ansible-galaxy collection install <collection name>`

- Collections are packages of modules, roles, plugins, etc in a self-contained manner, designed for specific purposes.
- Community and vendor-created collections are available.

- Collections offer:
  - Expanded functionality
  - Modularity and Reusability in playbooks, pone can define the collections used in a playbook as a list under `collections`
  - Similified distribution and management of playbooks, defining the required collections in a `requirements.yaml`, which can then be referenced when installing the required collections: `ansible-galaxy collection install -r requirements.yaml`
  