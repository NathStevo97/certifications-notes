# 5.02 - Vault UI for Production

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview

- By default, the Vault GUI is disabled for production. It can be enabled via the Vault config file however.
- All that is needed is adding the following to the config file:

```go
ui = true # boolean
```

- Note: For production environments, you may wish to update the private address of the server under `listener`.
- You can verify the system is listening to the desired address using `netstat -ntlp`
- Once the Vault is unsealed, ensure that the desired port for HashiCorp Vault is open - in this case `8200`, to allow the user to access the Vault UI.

<aside>
💡 Note: When accessing the UI whilst the Vault is in a sealed state, users are able to provide the unseal keys to unseal the vault

</aside>