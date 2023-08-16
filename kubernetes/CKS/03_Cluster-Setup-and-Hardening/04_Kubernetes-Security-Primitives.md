# 3.4 - Kubernetes Security Primitives

- Securing the hosts can be handled via methods such as disabling password
authentication and allowing only SSH Key authentication
- Controlling access to API Server is the top priority - All Kubernetes operations
depend upon this.
- Need to define:
  - Who can access the API Server?
  - What can they do with the API Server?
- For access, could use any of:
  - Files
  - Certificates
  - External authentication providers
  - Service Accounts
- For Authorization:
  - RBAC - Role-based access control
  - ABAC - Attribute-based access control
  - Node Authorization
- By default, all pods within a cluster can access one another
- This can be restricted via the introduction of network policies