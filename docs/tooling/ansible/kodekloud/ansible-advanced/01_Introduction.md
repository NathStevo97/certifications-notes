# 1.0 - Introduction

- [1.0 - Introduction](#10---introduction)
  - [1.2 - Recap](#12---recap)
  - [1.4 - Note on Enabling SSH in the VMs](#14---note-on-enabling-ssh-in-the-vms)
  - [1.6 - Environment Setup: Virtualbox](#16---environment-setup-virtualbox)
  - [1.7 - Environment Setup: Docker Containers](#17---environment-setup-docker-containers)

## 1.2 - Recap

- In the previous course:

[Ansible for Beginners](https://www.notion.so/Ansible-for-Beginners-f5daddb3ec374428a263dda867c99cc9)

- Ansible was introduced, showing how it can be used for a variety of operations e.g.@
  - Infrastructure Provisioning
  - Configuration Management
  - Application Deployment

- Various use case examples were shown and discussed for public and private cloud infrastructure.
- Ansible installation was discussed:

```bash
# Fedora
yum install ansible

# Ubuntu
apt-get install ansible

# PIP
pip install ansible
```

- Modules such as the following were discussed:
  - System
  - Commands
  - Files
  - Database
  - Cloud
  - Windows
- Variables were shown to be usable in playbooks, as well as conditionals and loops - all will be expanded upon in the course.

## 1.4 - Note on Enabling SSH in the VMs

- Ensure `/etc/apt/sources.list` has been updated  with the following 2 lines:
    1. `deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main`
    2. `deb http://ftp.de.debian.org/debian sid main`
- Comment the line starting `deb cdrom`
- Uncomment the 2 lines starting `deb` and `deb-src`
- Run the following:

```bash
apt-get update
apt-get install openssh-server
service sshd start
```

## 1.6 - Environment Setup: Virtualbox

- Use `ifconfig -a` to get the IP address for the machine
- Generally can just clone or create 2 other VMs after the controlplane creation.
- [Ansible Installation:](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Once installed on the required systems, create an inventory file for the target systems in the form of:

```bash
<hostname> ansible_host=<IP address> ansible_ssh_pass=<password>
```

- Test inventory usage with the example ping module:

```bash
ansible <target hostname> -m ping -i inventory.txt
```

- Note: One may need to modify the `/etc/ansible/ansible.cfg` file to disable host key checking, or just ssh to the systems from the controlplane; for practice, either are fine.

## 1.7 - Environment Setup: Docker Containers

- Ensure running a machine (VM or typical host) with Ansible and Docker installed.
- One can then deploy multiple containers with base ubuntu images. ([Example Image](https://github.com/mmumshad/ubuntu-ssh-enabled))
- The containers will be auto-assigned an IP based on Docker's internal network (`172.17.0.<x>` range)
- Verify installation via `ansible` and `docker`
- Create docker containers: `docker run -it -d  <image>`  (or use a Docker-compose file)
- Use `docker inspect <container id>` to get the container IPs
- Create an inventory file for each container and test connection with the ping module.
  - **Username:**: root
  - **Password:**: Passw0rd
