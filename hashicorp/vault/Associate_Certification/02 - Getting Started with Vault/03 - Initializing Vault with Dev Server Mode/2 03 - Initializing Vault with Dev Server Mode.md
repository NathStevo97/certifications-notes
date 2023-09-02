# 2.03 - Initializing Vault with Dev Server Mode

Complete: Yes
Flash Cards: Yes
Lab: Yes
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🔥🔥

# Notes

- Vault has two modes for operation:
    - Dev
        - Typically used for local development, testing, and practice
        - Very insecure
        - All data is stored in-memory ⇒ Any data stored will be lost upon restart
    - Prod
- Vault can be started as a server in "dev" mode via the following command:

```bash
vault server -dev
```

- Resultant output provides details regarding the vault server.

```bash
Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: false, enabled: false
```

- By default, the UI is available at the address listed against `Api Address`

![Untitled](./2%2003%20-%20Initializing%20Vault%20with%20Dev%20Server%20Mode/Untitled.png)

- To obtain the token for login - refer to the end of the output of the command used to start Vault in dev server mode, extract the root token and login to the UI:

```bash
The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: <Key>
Root Token: <Token>

Development mode should NOT be used in production installations!
```

- Once in the UI, menu options available will include:
    - Secrets - Secrets stored via various storage methods (engines)
    - Access -
    - Policies
    - Tools
- To verify the status of the Vault Server, use the `vault status` command, appending the server address via the —address option.

```bash
vault status --address=$VAULT_ADDR
```

- Where $VAULT_ADDR is the address of the Vault server provided at Vault initialisation.
- To stop the server, simply use `CTRL+C` on the terminal where Vault is running. Note that upon restart, the root token will be different.