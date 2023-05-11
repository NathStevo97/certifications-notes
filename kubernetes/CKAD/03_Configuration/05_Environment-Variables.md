# 3.5 - Environment Variables

- For a given definition file, one can set environment variables via the `env:` field in containers spec.
- Each environment variable is an array entry, with a name and value associated:

```yaml
env:
- name: <ENV NAME>
  value: <VALUE>
```

- Environment variables may be set via 1 of 3 ways (primarily):
  1. Key-value pairs (above)
  1. ConfigMaps
  1. Secrets

- The latter two are implemented in a similar manner to the following respective examples:

```yaml
env:
- name: <ENV NAME>
  valueFrom:
    configMapKeyRef:
```

```yaml
env:
- name: <ENV NAME>
  valueFrom:
    secretKeyRef:
```