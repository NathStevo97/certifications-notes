# 10.0 - Vault

Status: Done

# 10.1 - Introduction

- In bad practice, credentials are stored in plaintext e.g. in inventory files.
- Ansible Vault can be leveraged to store credentials in an encrypted manner.
- To encrypt a file: `ansible-vault encrypt <filename>`
- If using an encrypted file in a playbook, append `-ask-vault-pass`  to the `ansible-playbook` command
- Or store the vault password in a file and add `-vault-password-file <path to file>`
    - An alternative could be use a python file as a <path to file> substitute that looks for the password on the system and passes it in an encrypted form
- To view an entry within the vault, use `ansible-vault view <filename>`