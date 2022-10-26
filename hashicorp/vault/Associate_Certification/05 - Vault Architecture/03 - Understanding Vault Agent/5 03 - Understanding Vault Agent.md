# 5.03 - Understanding Vault Agent

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Challenges

- For applications needing to interact with Vault, they must first authenticate to Vault and then use the tokens for their required tasks.
- Outside of this, logic related to token renewal, etc may be required with the application.
- Rather than building custom logic for the application(s), the Vault agent can be utilised.

## Vault Agent Overview

- A client daemon that automates the workflow of client login and token refresh.
- It automatically authenticates to Vault for supported auth methods.
- It ensures tokens are renewed by re-authenticating as required, until renewal is no longer allowed.
- Additionally, it is designed with robustness and fault-tolerance in mind.

The Vault agent works as follows:

1. Authenticates and acquires a token via the configured auth method
2. The token is written to the backend
3. The token is used to authenticate to Vault

## Running Vault Agent

- To use the Vault agent, the binary can be ran in “agent mode”
- To do so, run `vault agent config=<config file>`
    - The agent configuration file must specify the auth method and sink locations where the tokens are to be written.

## Working of Vault Agent

- When Vault is started in agent mode, it will attempt to get a Vault token via the auth method specified in the agent config file.
- Upon successful authentication, the token is written to the sink locations.
- Whenever the current token’s value changes; the agent writes to the sinks.

## Practical Example:

- Various Auth methods are available, including AppRole, Azure, and AWS.
- Ensure the AppRole Auth method is enabled either via the CLI or UI
    - `vault auth enable approle`
- Create a policy for the agent. An example follows:

```go
path "auth/token/create" {
  capabilities = ["update"]
}
```

- Create an approle to use the policy defined above: `vault write auth/approle/role/<role name> token_policies="<policy name>"`
- Fetch the role ID: `vault read auth/approle/role/<role name>/role-id`
- Obtain the secret ID: `vault read auth/approle/role/<role name>/secret-id`
- Add the following code (example) at minimum to the agent config file (written in HCL):

```go
exit_after_auth = false
pid_file = "./pidfile"

auto_auth {
	method "approle" {
		mount_path = "auth/approle"
		config = {
				role_id_file_path = "/path/to/role-id" # files must exist!
				secret_id_file	_path = "/path/to/secret-id" # files must exist!
				remove_secret_id_file_after_reading = false
		}
}

sink "file" {
	config = {
		path = "/path/to/token"
	}
}

vault {
	address = "http://127.0.0.1:8200
}
```

- Start the Vault in agent mode via `vault agent -config=/path/to/file.hcl`
    - Information provided regarding the sink file with the token
    - This can be looked up via `vault token lookup <token>`
- Now, any application wishing to use the token must fetch it from the sink file location. As an example, a Kubernetes secret could be based on this.