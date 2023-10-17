# 5.07 - Auto-Unseal with AWS KMS

## Setting up AWS Auto-Unseal From Scratch

- As a prerequisite when implementing auto-unseal, you should have an understanding of the mechanism to be used.
- From Services → Key Management Service (KMS)
  - Create a symmetric key
  - Leave all settings as default (unless otherwise)
- Create an IAM user for authentication.
  - Provide sufficient permissions (Admin for demo purposes)
  - Note the access and secret keys associated with the IAM users.
    - Typically, one would export them as environment variables for security purposes.
- Add the following to the Vault Server Config file:

```go
seal "awskms" {
 region = "<region code>"
 access_key = "<access key>" # typically included as env variable instead
 secret_key = "<secret key>" # typically included as env variable instead
 kms_key_id = "<kms key id>"
 endpoint = "<KMS API endpoint>" # optional - typically used for private connactions over vpc from an EC2 instance
}
```

- Starting the Vault using this config: `vault server -config <config>.hcl`
- Upon first starting, an error/warning will be provided saying that no keys were found. Vault must be initialized to provide the master key and key shares.
  - `vault operator init`
  - Provides the root token and recovery keys
  - This will automatically unseal the vault.
  - The keys generated are automatically stored into the kms - they can now be called automatically for future usage of Vault.
