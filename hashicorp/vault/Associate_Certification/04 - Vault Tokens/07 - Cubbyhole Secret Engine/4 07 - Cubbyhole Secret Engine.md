# 4.07 - Cubbyhole Secret Engine

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview

- Cubbyhole secrets engine provides a private secret storage space unreadable by any other users (including root).
- One cannot reach into another token's cubbyhole, even as the root user.
- This secrets engine is enabled by default. It cannot be disabled/moved/enabled.
- In the cubbyhole secrets engine, paths are scoped per token.
  - When the token is expired, the associated cubbyhole is destroyed.
- By DEFAULT - Cubbyhole secrets engine will already be in place for any user that has the default policy assigned.
  - The default policy allows users to create/read/update/delete/list all secrets in their particular cubbyhole
- All operations in the cubbyhole user is facilitated using the user's particular token at the time of login.
  - Suppose a user logs in and has a new token generated - that token will not be able to do anything with the secrets.
  - Verify via `vault read cubbyhole/<path>`
    - One must use the same token used creating the secret e.g. if creating it in the UI, that token must be used via `vault login <token>`
-
