# 4.01 - Overview of Vault Tokens

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Tokens Overview

- Tokens are the core method for authentication within Vault
- With `vault server -dev` the root token has been used
    - This is the first method of authentication for Vault and the only auth method that cannot be disabled

## Mapping of Tokens to Policies

- Within Vault, tokens map to information. The key mapping noted is a set of one or more policies e.g. the default policy maps to all users.

## Practical

- Create a sample user under the userpass method e.g. demouser / password
- Under “tokens” you can select “do not attach default policy” - typically don’t want it assigned anyways as it offers minimal privileges
    - Can see upon login via `vault login -method=userpass username= password=` that no policy will be assigned
- Creating a sample policy via Policies → Create:
    - Under the user the desired policy(ies) can be assigned under “generated token’s policies”
    - This can then be verified via re-logging in and attempting operations on any secrets specified
- Note: no policy changes can take effect unless the user with the token logs out and back in so a new token can be generated with the updated mapping.

## Lookup Token Information

- Users can explore the details of a token with the command `vault token lookup`
    - This will work for the user logged in to Vault
- Note: to use - the read capabilities must be added to a policy for the path `auth/token/lookup-self`
    - Information provided include policies, paths, ttl
- For root-related ops:
    - `vault login <root token>`
    - `vault token lookup`
- For any other tokens - append the token desired to `vault token lookup`