# 5.7 - Manage Kubernetes Secrets

- Used to store sensitive information e.g. passwords and keys
- Similar to configmaps but stored in hashed format
- Secrets must first be created before injection
- Creation via commands or a definition file:
  - Imperative: `kubectl create secret generic <secret name> --from-literal=<key>=<value>, ...`
    - Or use: `--from-file=/path/to/file`
  - Declarative:
    - Create a `secret.yaml` file
      - Under data - add secrets in key-value pairs
- To encode secrets: `echo -n 'secret' | base64`
- Secrets viewable and manageable via kubectl < task > secrets
- To view secrets values: `kubectl get secret <secret> -o yaml`
- To decode, use the `| base64` command with `--decode` flag
- Secrets can then be injected into pods as environment variables using the envFrom
field
  - One can also reference the secret directly using env // valueFrom
  - Alternatively, volumes can be used, but this isn't recommended.