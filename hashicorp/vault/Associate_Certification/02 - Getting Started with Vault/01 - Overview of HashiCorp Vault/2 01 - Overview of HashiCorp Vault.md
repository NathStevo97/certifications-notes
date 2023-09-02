# 2.01 - Overview of HashiCorp Vault

Complete: Yes
Flash Cards: Yes
Lab: Yes
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🔥🔥

# Notes

---

## Getting Started

- Vault allows enhanced management and storage of secrets such as tokens, passwords, tokens, certificates, etc.
- Secret management in general is one of the most common and high-priority challenges faced by organisations - this generally includes storage, access management, and rotation of secrets.
- Secrets include anything from database passwords, AWS access/keys, API tokens, encryption keys, etc.

---

## Dynamic Secrets and Vault Console

- As discussed in the previous section, Vault aims to offer Dynamic Secrets i.e. users request the credentials from Vault, the credentials generated are then rotated based on the policies set.
- Vault was previously CLI-only, but is now packaged with a UI / Console to help with management.
- This console can be easily used to generate new credentials for many different secret types.
- This can be viewed via the Vault CLI, the following command provides credential details including password, username, and lease time:

```bash
vault read database/creds/readonly
```

- Other functionalities include encryption.
- In general, once installed, Vault can remove the manual aspect of many secret management tasks, allowing engineers and admins to spend more time on the work they're required for.