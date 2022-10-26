# 5.04 - Vault Agent Caching

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Primary Functionalities of Vault Agent

- Auto-Auth
    - Automatically authenticates to Vault and manages the token removal process
- Caching
    - Allows client-side caching of responses containing newly-created tokens.

## Overview of Caching

- Vault Caching follows a particular general process:
1. Application/Service requests a lease or token from Vault Agent
2. **Vault Agent Response: Upon Receiving the Request, Vault checks its Cache**
    1. If the requested lease or token is in cache, it is returned to the app/service
    2. If not found in the cache, a request is forwarded to Vault Server to obtain the lease or token
3. If step 2b occurred, Vault Server returns the requested lease or token
4. The returned lease or token is stored in the Agent Cache of the Vault client; then returned to the application or service for usage.

## In-Practice

- When looking to utilise the caching mechanism of the Vault agent, two particular areas must be added to the config:

```go
cache {
	use_auto_auth_token = true
}

listener "tcp" {
	address = "127.0.0.1:8007"
	tls_disable = true
}
```

- Starting the vault using the config: `vault agent -config=/path/to/config.hcl`
- Run a test command: `<token> vault token create`
    - No logs will appear in the agent logs as this request goes directly to the Vault Server
    - To resolve, `export VAULT_AGENT_ADDR=127.0.0.1:8007`
    - If the request is made again, the same token will be returned rather than a new one generated - this is because the original token was stored in the cache of the agent.
- In separate users, so long as they have the Vault Agent Address variable set, they will not require a token to run commands as the client token is used.