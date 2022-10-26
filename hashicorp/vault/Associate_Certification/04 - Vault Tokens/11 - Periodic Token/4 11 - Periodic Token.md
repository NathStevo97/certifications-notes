# 4.11 - Periodic Token

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Overview

- Periodic tokens = tokens that never expire (so long as they are renewed)
- Aside from root tokens, periodic tokens are currently the only way for a token in Vault to have an unlimited lifetime e.g. to work so long as a service is running.
- To create a periodic token - `vault token create -period=<time>`
- Note - a similar scenario is NOT achievable via repeatedly doing `vault token renew` as this will conflict with the max ttl of the associated auth method.
- Note - warnings are always provided with periodic tokens - this may be due to the period value exceeding the max TTL.
- Note: Periodic tokens should only exist for as long as required e.g. until a service has done its job!