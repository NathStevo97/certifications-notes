# 07.1 - Ansible Variables

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Notes

- Variables are used in a very similar manner to other programming / scripting languages.
- Could be used to allow changeability of username / host details.
- Ansible inventory files can be the prime point for variables
- Variables can be added in playbooks in a similar manner to:

![Unvariablised Playbook](images/playbook-no-vars.png)

- Alternatively, they can be included in a separate variables file and referenced by “incudes” functions, more on that in a later section:

![Variable Example](images/var-example.png)

## Using Variables

- To use variables, enter the variable name in ‘{{}}’ i.e.

![Playbook-Vars Example](images/playbook-vars-example.png)

- Example two - using inventory file playbooks. variable yaml files etc:

![Extended Vars Example](images/extended-vars-example.png)

- Note - This is Jinja Templating!