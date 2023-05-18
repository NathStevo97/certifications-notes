# 02.2 - Setup Lab: Clone VMs and Install Ansible

Complete: No
Flash Cards: No
Lab: Yes
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🔥🌚

# Notes

- Now that a base template VM has been created, we can create clone VMs from this for the purposes of the practice labs.
- Linked clones are generally preferred as the only additional storage required for them is any changes made to them outside of the base VM e.g. installed packages.
- To create a linked clone, select “manage” from the VM library pane for the template VM, then follow the wizard to create a clone from the current state of the VM and make it a “linked” clone.
- Just creating “ansible-target” and “ansible-controller” for now, will add one more ansible target later.
- Verify that the IP addresses of the two machines are different via any of the following `ifconfig`, `hostname -i`, etc, and ssh into them from Powershell
- For ease of use, it’s better to create a dedicated ssh session to these vms via a tool such as MobaXterm
- To change the hostname of the system (to make it reflect ansible-controller and ansible-target), edit /etc/hostname, and /etc/hosts as appropriate.
    - for the latter, after the first “localhost” on each line, delete and replace with “ansible-controller” or ansible-target1” as appropriate
- Create another linked clone and name it target2, repeating the process for target1.
- Can now install ansible on the ansible-controller VM, instructions can be found via the Ansible documentation.
    - For our CentOS VMs run
    
    ```bash
    $ sudo yum install epel-release
    $ sudo yum install ansible
    ```
    
- Verify that ansible is installed via:

```bash
ansible --version
```

The output should be similar to:

```bash
ansible 2.9.27
config file = /etc/ansible/ansible.cfg
configured module search path = [u'/home/nstephenson/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
ansible python module location = /usr/lib/python2.7/site-packages/ansible
executable location = /usr/bin/ansible
python version = 2.7.5 (default, Oct 14 2020, 14:45:30) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]
```