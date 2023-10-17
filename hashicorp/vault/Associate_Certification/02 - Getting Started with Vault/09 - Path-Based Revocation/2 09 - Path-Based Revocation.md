# 2.09 - Path-Based Revocation

- When revoking leases in HashiCorp Vault, there are typically two main methods:

| Command | Description |
| --- | --- |
| `vault lease revoke <lease id>` | Revoke a lease of particular ID |
| `vault lease revoke -prefix aws/` | Revoke all AWS access keys - substitute AWS with the prefix associated with the desired secret engine |

- Lease IDs are structured in a way such that their prefix is always the path where the secret was requested from - this allows trees of secrets to be revoked by prefixes.
