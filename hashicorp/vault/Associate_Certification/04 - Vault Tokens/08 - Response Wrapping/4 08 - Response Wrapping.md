# 4.08 - Response Wrapping

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview

- As outlined in AppRole usage i.e.
    - Policy and role for app created
    - Role ID and Secret ID are generated
    - Role ID and Secret ID are passed to and used by the app to authenticate to Vault, which returns a token.
- Response Wrapping aims to secure this process. The steps are outlined as follows:
    1. AppRole Auth Backend is mounted
    2. Policy and Role created for app
    3. Role ID received by Trusted Entity (Terraform, Kubernetes, Ansible, etc.)
    4. Role ID Delivered to app
    5. The Trusted Entity (Terraform, Kubernetes, etc.) receives the wrapped secret ID from Vault
    6. Vault returns the wrapping token to the trusted entity
    7. The trusted entity delivers the wrapping token to the app
    8. The app uses the unwrapping token to unwrap the secret ID stored in the Vault
    9. The app logs in via the Role ID and Secret ID

## Working

- When the response wrapping is requested, Vault creates a temporary single-use token (wrapping token)
    - The wrapping token is inserted into the token's cubbyhole with a short TTL
- Only the expecting client who has the wrapping token can unwrap this secret.
- If the wrapping token is compromised and the attacker unwraps the secret, the application will not be able to unwrap again
    - This can be used in conjunction with monitoring tools to implore admins to revoke the appropriate tokens.

## In Practice

- New tokens can be created by `vault token create`
    - This displays the token in plaintext
- Use `vault token create -wrap-ttl=<time in seconds>`
    - This displays the wrapping token that can be used to unwrap the secret associated
    - `vault unwrap <wrapping token>`