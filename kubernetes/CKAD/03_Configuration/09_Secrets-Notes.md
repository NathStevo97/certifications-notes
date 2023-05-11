# 3.9 - Secrets Notes

- Secrets are encoded in base64 format -> this can easily be decoded
- It's thought that secrets are a safer option, but this is only in the sense that "it's better than plaintext".

- It's the practices regarding secret storage that makes them safer, including:
  - Not checking-in secret object definition files to source code repositories
  - Enabling encryption-at-rest for secrets

- Kubernetes takes some actions to ensure safe handling of secrets:
  - A secret is only sent to a node if a pod on said node requires it
  - Kubelet stores the secret into a temporary file storage so it's not persisted to a disk.
  - Once a pod is deleted, any local copies of secrets used by that pod are deleted.

- For further improved safety regarding secrets, one could also use tools such as Helm Secrets and HashiCorp Vault.