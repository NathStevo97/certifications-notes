# 9.2 - Authentication, Authorization and Admission Control

- Controlling access to API Server is the top priority
- Need to define who can access the API Server through and what they can do
- Could use any of:
  - Files
  - Certificates
  - External authentication providers
  - Service Accounts
- By default, all pods within a cluster can access one another
- This can be restricted via the introduction of network policies.
