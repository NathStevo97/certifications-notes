# 4.09 - Overview of Batch Tokens

- [4.09 - Overview of Batch Tokens](#409---overview-of-batch-tokens)
  - [Overview](#overview)
  - [Analysis](#analysis)
  - [In Practice](#in-practice)

## Overview

- Batch tokens are encrypted blobs to carry information to be used in Vault actions - but they do not require any on-disk storage to track them.
- With Vault Replcication enabled, the pressure on storage backend increases as the number of token or lease generation requests come in.
- As batch tokens don't require disk storage, making them very lightweight and scalable, they serve as a strong solution to the problem.
  - The caveat is however, they lack a lot of flexibility in comparison to a standard service token.

## Analysis

| Feature | Service Token | Batch Token |
| --- | --- | --- |
| Can be root tokens | Yes | No |
| Can create child tokens | Yes | No |
| Renewable | Yes | No |
| Periodic | Yes | No |
| Can have particular max TTL | Yes | No (fixed TTL always) |
| Has Accessors | Yes | No |
| Has CubbyHole | Yes | No |
| Revoked with Parent if not orphan | Yes | Stops Working |
| Dynamic Secrets Lease Assignment | Self | Parent (if not orphan) |
| Can be used across performance replication clusters | No | Yes (if orphan) |
| Creation scales with performance standby node count | No | Yes |
| Cost | Heavy Weight - Multiple Storage Writes per token creation | Lightweight - No storage cost for token creation |

## In Practice

- To create a batch token, the `-type` flag is used to specify a `batch` token. Note that by default, if this is not provided a service token is provided.
- Example: `vault token create -type=batch -policy=default`
