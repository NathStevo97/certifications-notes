# 5.09 - Audit Devices

## Overview

- Components in Vault that log requests and responses to Vault.
- As each operation is an API request/response - the audit log includes every authenticated interaction with Vault; including errors.
- By default, auditing is not enabled. It must be enabled by a root user using `vault audit enable`.

## In Practice

- To enable file audit: `vault audit enable file file_path=path/to/file.log`
- Audit mechanisms in place can be viewed by `vault audit list`
- Note: The audit log is by default in JSON format.
- Details logged include:
  - Client token used
  - Accessor
  - User
  - Policies involved
  - Token type.
- Note: Other options are available:
  - Syslog
  - Socket
- Enabling in Linux:
  - `vault audit enable -path="audit_path" file file_path=/var/log/vault-audit.log`
    - Audit log stored at /var/log
    - viewable via `cat <audit log> | jq`
- Note: The client token value is hashed - this can be computed via the endpoint `/sys/audit-hash`
  - Sample request:
    - `vault print token` - gets the original token in plaintext

        ```go
        curl --header "X-Vault-Token: <vault-token>" --request POST --data @audit.json http://127.0.0.1:8200/v1/sys/audit-hash/<path>
        ```

## Important Pointers

- If there are any audit devices enabled, Vault requires at least one to persist the logs before completing a request.
- If only one device is enabled and is blocking; Vault will be unresponsive until the audit device can write.
  - If more than one audit device is enabled in addition to the blocking one, Vault will be unaffected.
