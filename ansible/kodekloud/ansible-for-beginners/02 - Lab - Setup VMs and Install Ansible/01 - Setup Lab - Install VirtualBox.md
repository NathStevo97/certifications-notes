# 02.1 - Setup Lab: Install VirtualBox

## Notes

- The labs for this course and project are advised to be done on Virtualbox, the free Virtualisation tool.
- Whilst this program is free and can be downloaded from [here](https://www.virtualbox.org/), its UI, functionality, and performance pales in comparison to the likes of VMWare, which I'll be using for this.
- In reality, as long as you can run VMs on the tool and can make linked clones, you're good to go.
- Steps:
  - Create a template VM from a CentOS base machine
  - Create an Ansible Control Machine and two Target Machines for the Control Machine to apply configurations
- Once the template VM is setup, make sure that the network connection is set to bridged (VMNet0) and verify this appropriately.

---
