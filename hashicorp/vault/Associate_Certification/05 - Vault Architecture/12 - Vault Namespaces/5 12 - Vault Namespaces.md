# 5.12 - Vault Namespaces

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Background Context

- In organizations, there are typically multiple teams wanting to use services such as Vault for their own particular purposes.
- In the case of Vault, they would need to manage their own secrets, auth methods, etc.
- To allow for this segregation and minimizing impacts teams may have on one another, Namespaces can be used.
- Each Vault namespace can have its own:
    - Policies
    - Auth Methods
    - Secrets Engines
    - Tokens
    - Identity entities and groups.

## In Practice

- When logging into Vault, you can specify the namespace to log into if desired.
- Namespaces are created under `Access` in the Vault GUI.