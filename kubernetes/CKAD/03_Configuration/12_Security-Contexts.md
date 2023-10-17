# 3.12 - Security Contexts

- Container security may be configured by adding or specifying users and their associated capabilities in the `docker run` command.
- Similar settings may also be handled via Kubernetes.

- As containers are hosted within pods on Kubernetes, one can either configure security at the pod or container level.
  - If configured at pod level, any changes will automatically be applied to the containers within.
  - If configured at container level, these settings will override anything defined at pod level.

## Security Context

- To configure security in the definition file, add the `securityContext:` attribute
- User is set by `runAsUser: <user ID>`
- To configure at container-level, add the same fields to the containers list
- To add capabilities, add `capabilities:`, then in a dictionary, add `add: ["<CAPABILITY ID>", .... ]`.

- **Note:** Capabilities are only supported at container-level, not pod-level.
