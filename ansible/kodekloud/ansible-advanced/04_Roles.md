# 4.0 - Roles

Status: Done

# 4.1 - Roles Introduction

- Recommended way of developing playbooks
- Allows for organization of project in a standard structure and for reusable tasks
- Role creation automatically creates a folder structure for it, containing:
    - README
    - tests folder
    - tasks folder
    - handlers folder
    - vars folder
    - defaults folder
- To use a role, implement it at the top level of the playbook in a similar manner to:

```yaml
- name: <Playbook>
  hosts: web
  roles:
  - rolename 1
  - rolename 2
```

- Doing so will include everything defined under the role folder, removing the need for "includes" statements.
- This keeps the playbook simple, and allows the role to be reused elsewhere.
- Roles can then be shared to ansible-galaxy for use.
- Create a role with `ansible-galaxy init <rolename>`  or create the folder structure manually
- With roles, the originally monolithic application can be distributed, having the application running on 1, and the database on another.

---

# 4.2 - Publishing Roles to Ansible-Galaxy

- Login to [https://galaxy.ansible.com](https://galaxy.ansible.com)
- Navigate to the roles directory
- For each role:
    - cd into the role
    - Ensure the README and metadata/main.yaml files are updated as required. For the latter:
        - Uncomment platforms section
        - Add any galaxy_tags desired
    - Add the role to a designated Github repository
    - Via ansible galaxy, import the role from github.