# 4.10 - Token TTL Configuration

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Recap

- Every non-root token has a Time to Live (TTL) - defining how long the token remains valid for.
- After the TTL expires, the token no longer functions and any associated leases are revoked.

## TTL Dependency

- TTLs are dependent on a combination of multiple factors, such as:
    - The system’s max TTL - 32 days
        - This can be configured in Vaults configuration file.
    - The max TTL set on a mount using mount tuning
    - A value suggested by the auth method issuing the token.
- The default and max lease ttl can be configured via the following: `vault write sys/mounts/auth/token/tune` and appending either or:
    - `default_lease_ttl=<time>`
    - `max_lease_ttl=<time>`
- To configure a new default and max lease TTL for an auth method, this can be configured during setup of the auth method