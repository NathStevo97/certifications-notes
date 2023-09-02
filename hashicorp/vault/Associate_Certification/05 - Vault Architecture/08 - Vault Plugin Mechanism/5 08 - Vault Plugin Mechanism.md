# 5.08 - Vault Plugin Mechanism

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview

- Plugins are the building blocks of Vault. All auth and secret backends are considered plugins.
- This allows Vault to extensible to suit user needs.
- This doesn't just apply to pre-existing plugins, custom plugins can also be developed.
- In general, to integrate a 3rd-party plugin, the following steps need to be done:
    - Create the plugin
    - Compile the plugin
    - Start Vault pointing towards where the plugin is stored.

## In Practice

- Install any desired packages e.g. go, git, etc. (Use Apt, Yum, etc as appropriate)
- Clone the code down for the plugin using GIT e.g. vault-guides/secrets/mock
- Compile the plugin using go: `go build -o /path/to/output/dir`
- Start Vault, pointing to the plugin directory: `vault server -dev -dev-root-token-id=root -dev-plugin-dir=/path/to/dir`
- Test the plugin functionality:
    - `export VAULT_ADDR="http://127.0.0.1:8200`
    - `vault login root`
    - `vault secrets enable my-mock-plugin`
    - `vault secrets list`
        - Verify the plugin is working and the secret path exists.
    - Read and Write operations to the plugin path:
        - `vault write my-mock-plugin/test message="Hello World"`
        - `vault read my-mock-plugin/test`

## Production

- In production, to use plugins, the following should be added to the config file: `plugin_directory = /path/to/directory"`