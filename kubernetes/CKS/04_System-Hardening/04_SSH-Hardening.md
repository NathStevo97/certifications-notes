# 4.4 - SSH Hardening

- SSH used for logging into and executing commands for remote servers
- General access via any of the following commands:
  - `ssh <hostname or IP address>`
  - `ssh <user>@<hostname or IP address>`
  - `ssh -l <user> <hostname or IP address>`
- Remote server must have an SSH service running and port 22 opened for communication
- Additionally, a valid username and password for the user should be created on the remote server; or an SSH key.
- To maximise security for access:
  - Generate key pair (public and private key) on the client system
  - Public key shared with remote server
  - Creation: `ssh-keygen -t rsa`
    - Enter passphrase = optional, but enhances security
    - Public key and private key stored at `/home/user/.ssh/id_rsa.pub` and `/home/user/.ssh/id_rsa respectively`
  - Copy public key to remote server: `ssh-copy-id <username>@<hostname>`
    - Password required for authentication on the server; shouldn't be required after key copying
  - On the remote server, the keys should be stored at `/home/user/.ssh/authorized_keys`
- Hardening the SSH service:
  - On the remote server; can configure the SSH service to enhance security.
  - Possible actions:
    - Disable SSH for root account - no one can log into the system via the root account, only their personal user or system accounts
- In line with the principle of least privilege
  - Requires updating of the ssh config file, located at `/etc/ssh/sshd_config` -> set PermitRootLogin to no
  - Could also disable password-based services if using SSH key based authentication -> set `PasswordAuthentication` to no
  - Once changes are applied, restart the service: systemctl restart sshd
- Additional information available via section 5.2 of the CIS Benchmarks
<https://www.cisecurity.org/cis-benchmarks/>
