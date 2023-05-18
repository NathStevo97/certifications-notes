# 01.1 - Introduction

Complete: No
Flash Cards: No
Lab: No
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🌚🌚

# Notes

- Course content via lectures, hands-on exercises and practice projects to work on.
- Course Objectives:
    - Introduction to Ansible
    - Setting up Labs
    - Introduction to YAML
    - Inventory Files
    - Playbooks
    - Variables
    - Conditionals
    - Loops
    - Roles
    

## Introduction to Ansible

Why Ansible?

- In system administration (or similar) roles, many tasks are often repetitive, such as:
    - Provisioning
    - Configuration Management
    - Continuous Delivery
    - Application Deployment
    - Security and Compliance Audits
- These tasks usually require many commands that must be run in a correct sequence on multiple machines
- This was typically done by using scripts, however this would require coding skills, something which Ansible does not.
    - As an example, suppose a script was developed to add a particular user, this would require many lines of code.
    - In an Ansible Playbook, this just requires 4 lines tops, the Playbook can be configured to then run on ANY set of machines that the configuration is required.
- Example:
    - Consider an environment that requires restarting in a particular order,  e.g. power down web servers first, then databases, then start them back up in the reverse order.
    - This task can be handled by an Ansible Playbook within a matter of minutes
- Example 2:
    - Ansible could facilitate the provisioning of VMs across public and private cloud environments, even deploying applications to these environments.
- Database information can be fed into Ansible to help trigger builds e.g. if a request comes in from ServiceNow.

---