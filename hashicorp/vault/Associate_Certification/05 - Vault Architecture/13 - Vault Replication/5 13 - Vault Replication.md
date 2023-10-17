# 5.13 - Vault Replication

## Background Context

- Having a single Vault cluster can impose various challenges, such as:
  - High latency
  - Connection issues
  - Availability loss
- It is therefore beneficial to have multiple clusters across different regions; allowing users in region 1 to manage their own secrets, etc. in their closer region.
- Replication serves to resolve this. There are multiple types available.

## Performance Replication

- Secondary regions keep track of their own tokens and leases, but share the same underlying configuration, policies, and supporting secrets (K/V values, encryption keys for transit, etc.) with the primary region.

## Disaster Recovery Replication

- Allows for a full restoration of all types of data (including local and cluster data)
  - Service tokens and leases are valid across both clusters.
- The secondary cluster does not handle any client requests, and can be promoted to the new primary in the event of disaster.
