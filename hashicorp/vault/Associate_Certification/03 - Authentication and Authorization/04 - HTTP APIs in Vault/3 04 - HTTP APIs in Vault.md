# 3.04 - HTTP APIs in Vault

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Notes

- All of Vault’s capabilities are accessible via the HTTP API.
- Most CLI commands invoke the HTTP API, however, some Vault features can only be accessed via the HTTP API.
- Tools such as `cURL` can be used to make calls to the HTTP API. This requires the use of a client token, settable via the X-Vault-Token HTTP Header.
    - Example: `curl -h "X-Vault-Token: <token> -X GET http://127.0.0.1:8200/v1/secret/foo`
- All API Routes are prefixed with v1 bar a few documented exceptions.
- All response data from Vault is via JSON.
- The HTTP request types correspond to a particular Vault capability or operation:
    - 
    
    | Capability | HTTP Request Type |
    | --- | --- |
    | create | POST/PUT |
    | list | GET |
    | update | POST/PUT |
    | delete | DELETE |
    | list | LIST |

---

- Sample requests are well-documented for multiple secret types at https://vaultproject.io/api-docs/