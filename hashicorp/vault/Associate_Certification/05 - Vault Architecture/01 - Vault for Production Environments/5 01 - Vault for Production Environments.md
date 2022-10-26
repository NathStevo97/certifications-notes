# 5.01 - Vault for Production Environments

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Overview

- Up until this point, Vault has been used in development mode only.
- In this, all data is stored in-memory ONLY.
- This is obviously not suitable for production, a new storage class is required. Vault supports a multitude of storage class options, such as:
    - Filesystem
    - S3 Bucket (AWS)
    - Databases (MySQL, PostgreSQL, etc.)

## Deploying in Production Mode

- Vault servers are configured using a particular file in JSON or HCL.
- **Example config:**

```go
storage "file" {
	path = "/root/vault-data"
}

listener "tcp" {
  address      = "0.0.0.0:8200"
  tls_disable  = 1
}
```

- Once setup, the Vault can be started using the config file: `vault server -config /path/to file`
- As we’re using a new backend, once the Vault server is started, it must be initialized.
    - In this step, encryption keys are generated, as well as unseal keys and the initial root token.
    - To do so: `vault operator init`
    - This will output the Unseal keys and Root Tokens.
- Once initialized, the Vault must be unsealed. This is true of every initialized Vault.
    - Unsealing is required as Vault knows where to look in the particular storage backend, but it does not have the key to decrypting it and reading the data.
    - To unseal the Vault: `vault operator unseal`

## Practical Example:

- For any VMs used, ensure that SSH port 22 is open for ease of use.
- This example will be set up for Linux.
1. Creating the config file. The following areas should be added:
    1. Storage (required)
    2. Listener (required)
    3. Telemetry (optional)
    
    ```go
    storage "file" {
      path = "/path/to/vault/data" # path will be created if it doesn't exist!
    }
    
    listener "tcp" {
      address      = "0.0.0.0:8200"
      tls_disable  = 1 # shouldn't be disabled when running in production
    }
    ```
    
2. Starting the server: `vault server -config /path/to/config.hcl`
3. Initialize the Vault:
    1. Ensure `VAULT_ADDR` environment variable is set
    2. Verify vault operations by running `vault status`
    3. Run `vault operator init`
    4. Save the unseal keys and root tokens - they will disappear and be inaccessible after this!
4. Unseal the Vault: `vault operator unseal`
    1. Provide 1 of the 5 unseal keys provided
    2. Repeat two more times such that 3 of the 5 unseal keys have been provided.
5. You can test Vault operations by using e.g. `vault list auth/token/accessors`
    1. This will fail though, as Vault in Production mode by default does not set the root token as the token for usage.
    2. Login via root `vault login` and provide the root token
        1. Future requests will automatically use the token.
        2. The same will be applied for any other tokens created (so long as the user has sufficient permission!)

---

## Verifying Storage Persistence

- As production mode persists storage, if Vault is shut down, the data isn’t deleted.
- Upon restart of Vault, the process outlined previously must be followed to unseal the vault and verify data persistence.

<aside>
💡 THE UNSEAL KEYS SHOULD NOT BE STORED WITH ONLY 1 PERSON - THEY SHOULD BE DISTRIBUTED AMONGST TEAM MEMBERS

</aside>