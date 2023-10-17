# 5.15 - High-Availability Setup & Implementation in Vault

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview of HA

- In general, running a single instance of anything is risky. Vault is no exception.
- Vault supports a multi-server mode for High-Availability. This further protects organisations against outages by running multiple servers.
  - The data will be replicated across each based on the "leader".

- **Note:** High-Availability IS STORAGE BACKEND DEPENDENT - Integrated Storage is also available to support this.

- Out-of the box, Raft is available for use, an integrated storage backend.
- To configure:

```go
storage "raft" {
  path = "/path/to/raft/data" # defines where the data will be stored
  node_id = "raft_node_1"
}
cluster_addr = "http://127.0.0.1:8201"
```

## In Practice

- Start three separate instances of Vault with the above config: `vault server -config=/path/to/config.hcl`
- List the raft peers: `vault operator raft list-peers`
  - One will be noted as "leader" under state
- Run a test command in the leader node to store data:
`vault kv put secret/dbcreds admin=password`
- On one of the follower nodes, test access to the secrets: `vault kv get secret/dbcreds`
  - The secret data should be displayed.
- In the event that the leader node goes down, the data will still be accessible AND a new leader node will be assigned.

## Implementing Vault HA

- Raft Storage can be configured by adding the following to the config file:

```go
storage "raft" {
  path = "/path/to/raft/data" # defines where the data will be stored
  node_id = "raft_node_1"
}
cluster_addr = "http://127.0.0.1:8201"
```

- You are advised to set `disable_mlock` to true and disable memory swapping on the system.
- Start the server with `vault server -config=/path/to/config`
  - The vault will be shown to operational with Raft storage ready
- In a separate terminal, initialise the Vault:
  - `vault operator init -key-shares=<value> -key-threshold=<value> > key.txt`
- Unseal: `vault operator unseal <unseal key>`
- Login: `vault login <token>`
- Check the Raft nodes: `vault operator raft list-peers`
- Repeat for each node/vault server as required up until initialisations:
  - `export VAULT_ADDR='address'`
  - Join the node to the server `vault operator raft join <leader IP address>`
- To verify, put a secret to a particular path e.g.:
  - `vault secrets enable -path=secret kv`
  - `vault kv put secret/creds admin=password`
  - On another node: `vault kv get secret/creds` - should return the secret.
- Test the replication and leadership transfer by restarting the leader node and running `vault operator raft list-peers`

## Important Pointers

- To be highly available, one of the Vault server nodes grabs a lock within the data store.
- The successful server node becomes the "active" node - all others become standby nodes.
- At this point, if the standby nodes receive a request, they will either forward the request or redirect the client depending on the configuration.
- Nodes can be stepped down from active duty by using the `vault operator step-down <address>` command.
