# 5.05 - Shamirs Secret for Unsealing Process

- [5.05 - Shamirs Secret for Unsealing Process](#505---shamirs-secret-for-unsealing-process)
  - [Overview](#overview)
  - [Notes](#notes)
  - [Seal Stanza](#seal-stanza)

## Overview

- Storage backend in Vault is considered to be untrusted.
- Any data stored is within the encrypted state.
- When vault is initialized, it generates an encryption key to protect all data stored within.
  - This key is then protected by a master key
- Vault then uses Shamir's secret sharing algorithm to split the master key into 5 separate shares, where any 3 of which can be used to reconstruct the master key.
  - This is why 3 keys must be used to unseal the vault.

## Notes

- The number of shares and minimum threshold required can both be specified.
- Shamirs technique can be disabled such that the master key can be used directly for unsealing.
- Once Vault receives the encryption key, it can decrypt the data in the storage backend and the Vault becomes unsealed

## Seal Stanza

- In the Vault server config file, the particular seal type can be configured if usage of Shamir's technique is not desired.

```go
seal [name] {
 # seal details
}
```

- This is optional configuration -  by default Shamir's algorithm will be used if not configured.
  - Most people tend to use this by default.
- Alternatives could include HSM or Cloud Key Management Solutions e.g. AWS KMS.
