# 4.06 - Overview of Orphaned Tokens

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Overview

- Orphan tokens are not children of any parent token - they therefore do not expire when the "parent" does
- They are the root of their own token tree, however orphan tokens still expire when their own max TTL is reached
- One can determine if a token is an orphan by checking the field of the same name when running a `vault token lookup` command
- To create an orphaned token:
  - `vault token create -orphan` as whichever user you desire that is capable of token creation.
  - Note: this would require a user with the following capabilities outlined in a policy:

    ```go
    path "auth/token/create" {
      capabilities = ["create", "read", "update", "sudo"]
    }

    path "auth/token/lookup" {
      capabilities = ["create", "read", "update"]
    }
    ```
