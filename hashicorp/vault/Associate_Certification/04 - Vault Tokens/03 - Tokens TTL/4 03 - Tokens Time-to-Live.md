# 4.03 - Tokens Time-to-Live

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Overview

- Time-to-Live (TTL) defines the lifetime of data
- Extensively used in regards to DNS mappings

# TTL For Tokens

- Every non-root token has a TTL
- After the TTL expires, the token will no longer function and any associated leases will be revoked

# Token Renewal

- Achieved by using the `vault token renew` command whilst logged in as a particular user
- Example: `vault token renew <token>`
    - Additional options available such as `--increment=<time>`

# Token Defaults

- Where does the default 768hr TTL come from?
- This is defined via the vault secret at `sys/auth/token/tune`
- Logging into root and reading this via `vault read sys/auth/token/tune`, the default lease TTL and maximum lease TTL is set to 768h