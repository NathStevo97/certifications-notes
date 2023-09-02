# 2.08 - Managing Leases

Complete: Yes
Flash Cards: Yes
Lab: Yes
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🔥🔥

## Overview of Lease

- With every dynamic secret and service type authentication token, Vault will create a lease.
- Leases are metadata containing information regarding how the credentials are used e.g. time to live (TTL), renewability, etc.
- Once the lease expires, Vault can automatically revoke the data such that the secret can no longer be used.
  - Dynamic credentials can be manually revoked regardless.
- To view leases, in Vault UI navigate to Access → Leases
  - From here, you can navigate to the lease associated with the role or secret engine that you wish to view or revoke.
  - The lease can easily be revoked by selecting "revoke lease"
- Lease TTL can be configured with two options:
  - Default TTL (seconds)
  - Maximum TTL (seconds)

> Note: When creating a role and noting a policy, you can also copy the policy ARN rather than the json policy.
>
- Prior to a Vault Lease Expiring you are able to request renewal of the lease either via the UI (selecting "renew lease" when viewing the lease") or running the following command:

```powershell
vault lease renew -increment=<time in seconds> path/to/lease
```

- This will extend the lease duration by the increment defined.

> Note: The default and maximum TTLs will vary depending on the organization, but they can be customised to suit and renewed via the methods above.
>

> If a user requests a renewal longer than the maximum TTL, the request will be denied.
>