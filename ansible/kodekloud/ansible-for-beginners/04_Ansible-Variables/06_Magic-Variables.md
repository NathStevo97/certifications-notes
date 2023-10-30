# 4.6 - Magic Variables

## Hostvars

- As discussed in previous sections, variables are scoped depending on where they are defined. If defined at a host level, host 2 traditionally has no access to variables defined for host 1, etc.
- If this did become a requirement, Magic Variables can be utilised.
- Used in the form `'{{ hostvars['<hostname>'].<var name> }}'`
- If additional facts are gathered by the hosts, vars such as the following can be used:
  - Host IP Address: `ansible_host`
  - Host system architecture: `ansible_facts.architecture`
  - Host mounts: `ansible_facts.mounts`

- **Note:** Magic variables may also be referred to via: `'{{ hostvars['<hostname>'][<var/var group name>][<sub-variable name>] }}'`

## Groups

- Group magic variables can be utilised in a few ways: `'{{ groups['<group_name>'] }}'` returns all the hosts under the particular group.
- `'{{ group_names }}'` will return the names of any group the particular host finds itself in.

## Inventory

- `'{{ inventory_hostname }}'` gives the inventory-level name for the host the play is running on.

---

- Other examples are available via the Ansible documentation.
