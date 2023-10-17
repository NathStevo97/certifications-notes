# 2.05 - Overview of Secrets Engine

## Notes

### Secret Engine Overview

- Secrets engines are components that **store**, **generate** or **encrypt** data.
- Secrets can be stored based on specific secret engines, each offer particular features.

![Untitled](./2%2005%20-%20Overview%20of%20Secrets%20Engine/Untitled.png)

### Secret Engine Types

- Similar to Terraform Providers, multiple secret engine types are available, each providing particular features for specific use cases. Examples include:
  - AWS
  - Active Directory
  - Key/Value
  - SSH
  - Azure

### Secret Engine Paths

- Secret engines are enabled at a given path. Once enabled, the secrets are stored at that particular path.
- You can control where a secret is installed via the following command:

```python
vault kv put <secret engine path>/<secret name> mykey=myvalue
```

### Secret Engine Lifecycle

- In general, engines can be:
  - Enabled
  - Disabled
  - Tuned
  - Moved

    | Option | Description |
    | --- | --- |
    | Enable | Enables a secrets engine at a particular path. By default, they will be enabled at their "type" e.g. "aws" enables at "aws/" |
    | Disable | Disables an existing secrets engine - this by default will revoke all secrets associated with the engine |
    | Move | Moves the path for an existing secrets engine, |

### Example - Key/Value Secret Engine

- The KV secrets engine stores arbitrary secrets within the configured physical storage for Vault
- Key names must always be strings
- Provides various functionalities e.g. versioning.
- Further information regarding secrets engines is available at [https://www.vaultproject.io/docs/secrets](https://www.vaultproject.io/docs/secrets)

    > Note: There are two versions of the kv secrets engine, version 2 is the latest.
    >
- Engines can be enabled via the CLI or the UI.

#### Enabling a Secrets Engine - UI

- From the home page, select `Enable new engine`
- Select the desired engine from the list provided, in this case, KV.

    ![Untitled](./2%2005%20-%20Overview%20of%20Secrets%20Engine//Untitled%201.png)

- Configure the `Path` AND the Maximum number of versions per key to keep, then enable the engine.
- The secret engine is now available for usage and can have secrets be created within.

#### Enabling a Secrets Engine - CLI

- To enable a secrets engine, run:

    ```powershell
    vault secrets enable -path=demopath -version=2 kv
    ```

    ![Untitled](./2%2005%20-%20Overview%20of%20Secrets%20Engine//Untitled%202.png)

### Disabling a Secret Engine

- To disable a secret engine via the CLI, run:

    ```powershell
    vault secrets disable <pathname>/
    ```

    ![Untitled](./2%2005%20-%20Overview%20of%20Secrets%20Engine//Untitled%203.png)
