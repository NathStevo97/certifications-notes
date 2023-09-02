# 4.04 - Lifecycle of Service Tokens

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Service Lifecycle of Tokens

- When a token holder creates a new token e.g. you create a token, the subsequent token is created as a "child" of the original token.
- If the parent is revoked or expires, as will all its children regardless of their own TTLs.
    - E.g. suppose token 1 is the parent of token 2.
    - If token 1 is not renewed, it is revoked by Vault, and as a result token 2 will be revoked.