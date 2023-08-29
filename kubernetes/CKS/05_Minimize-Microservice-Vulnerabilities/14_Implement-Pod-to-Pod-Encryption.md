# 5.14 - Implement Pod-to-Pod Encryption via mTLS

- By default, data transfer between pods is unencrypted -> This is a MAJOR security risk
- Pods can be configured to use mTLS though.
  - Similar to the previous example, but replace client and server with pod a and pod b respectively.
  - This ensures that both pods verify each other's identities.
- How would this be managed across multiple pods and nodes?
  - This is achievable by getting applications to encrypt communications by default, however this could then cause issues if there are differing encryption methods.
  - Typically, third party applications are used to facilitate the mTLS e.g. Istio and Linkerd
    - These are Service Mesh tools and aren't confined to mTLS only, they are typically used to facilitate microservice architecture
  - Tools like this run alongside pods as sidecar containers
  - When a pod sends a message to another, istio intercepts, encrypts and sends the message, where it is encrypted by the istio container running alongside the receiving pod.
  - Istio supports varying types of encryption levels / modes:
    - **Permissive / Opportunistic** - Will accept unencrypted traffic where possible / deemed safe
    - **Enforced / Strict** - No unencrypted traffic allowed at all