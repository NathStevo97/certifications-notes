# 5.06 - Vault Auto-Unseal Overview

## Background

- During Vault Unseal process, users must enter they key(s) required.
- This allows each share of the master key to be stored separately for improved security.
- This can lead to issues:
  - If there are multiple Vault clusters in an organization, unsealing them can be a tiresome process heavily dependent upon the availability of users with the keys.
  - Unsealing makes the process of automating a Vault install difficult.
    - Automation tools can easily install, configure and start Vault, but unsealing it via Shamir's technique is heavily manual.
- To resolve these issues, Vault's Auto-Unseal mechanism can be utilised.

## Auto-Unseal Overview

- This delegates the responsibility of securing the unseal key from users to a trusted device or service.
- At startup, Vault will connect to the device or service implementing the seal, then request it decrypt the master key, such that Vault can read from storage.
- Cloud-based key(s) provides master key information → Provided master key used to access encryption key and decrypt.
- This provides pre-setup via the desired unseal method e.g.:
  - AWS KMS
  - Transit Secret Engine
  - Azure Key Vault
  - HSM
  - GCP Cloud KMS
