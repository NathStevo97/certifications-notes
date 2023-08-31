# 4.3 - Limit Node Access

- As standard practice, exposure to the internet of the control plane and nodes
should be limited.
  - For self-hosted clusters or managed K8s clusters, this can be achieved via a
private network; access can then be achieved by a VPN
  - If running in the cloud, control plane access may be unlikely
- If implementing a VPN solution is impossible, one can enable authorized networks
via the infrastructure firewall
  - Allows/denies access from particular IP addresses
- Note: Attacks may not come from external sources, entities with network access
within the cluster may allow internal attacks.
  - One must therefore consider restricting access within the cluster.
  - Example - SSH Access:
    - Administrators require it
    - Developers do not require it usually and therefore they should be
restricted.
    - End users shouldn't have access too.
- Account Management - There are 4 types of accounts:
  - User accounts - Any individuals needing access to the system e.g. developers
system administrators
  - Superuser account - Root Account, has complete access and control over the
system
  - System Accounts - Created during the system development, used by software
such as SSH and Mail
  - Service Accounts - Similar to system accounts, created when services are
installed on Linux e.g. Nginx
- Viewing user details - Commands:
  - Id - provides details regarding user and group id
  - Who - lists who is currently logged in
  - Last - last time users logged into the system
- Access control files:
  - All stored under `/etc/` folder
    - `/passwd` - contains basic information about system users, including
user id and default directory
    - `/shadow` - contains the passwords for users, stored in hash format
    - `/group` - stores information about all user groups in the system
- The above commands and configuration files should be used to investigate user
permissions and access; limiting as appropriate based on least privilege principle.
  - Disable user account by setting default shell to a nologin shell:
`usermod -s /bin/nologin <username>`
  - Delete user - `userdel <username>`
  - Delete user and remove from group - `userdel <username> <groupname>`