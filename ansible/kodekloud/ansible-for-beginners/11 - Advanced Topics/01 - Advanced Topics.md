# 11.1 - Advanced Topics

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Preparing Windows Server

- Ansible Control Machines can ONLY be Linux Machines
- This does not mean that Windows cannot be targets of Ansible
- Ansible can still connect to a Windows host by WinRM
- To allow this, the follwing requirements must be met on the control machine:
    - pywinrm module installed - pip instlal "pywinrm≥0.2.2"
    - Setup WinRM - example scripts available online e.g. ConfigureRemotingForAnsible.ps1
    - Use / Configure other methods of authentication e.g. Basic / Certificate / Kerberos
- Additional information available in the Windows Support section of the Ansible documentation.

---

## Ansible-Galaxy

- A free site for sharing and rating community-developed Ansible Roles
- You are free to download any existing roles via the ansible-galaxy CLI to integrate them into projects.

---

## Patterns

- Have previously seen only [Localhost](http://Localhost) as the target host for playbooks
- Alternative options are available:
    - Host1, Host2, Host3
    - Group1, Host1 (where host1 isn't part of group1)
    - Host*
    - *company.com
- Additional options are available via the Ansible documentation.

---

## Dynamic Inventory

- It's not always necessary to define information in inventory files
- If the project was to be integrated to a new environment, the inventory file would have to change completely.
- To overcome this, one can make an inventory Dynamic
    - Instead of specifying the inventory.txt, you would specify a script called inventory.py
    - [Inventory.py](http://Inventory.py) reaches out to whatever sources are defined and returns their associated information

[https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html](https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html)

---

## Developing Custom Modules

- Modules already exist to perform specific actions like the user, file, etc.
- All of these are python modules
- Custom modules can be developed by building a python script in a particular format.
- Further information is available in the Ansible Documentation

---