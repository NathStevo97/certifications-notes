# 5.4 - Configure Environment Variables in Applications

- For a given definition file, one can set environment variable via the env field under
containers in a pod's spec
- Each environment variable is an array, so each one has its own name, value and is
denoted by a - prior to the name field

```yaml
env:
- name: APP_COLOR
  value: blue
```

- Environment variables can also be referenced via two other methods:
  - Configmaps: rather than env, replace with `valueFrom`, and add
`configMapKeyRef` underneath
  - Secrets: rather than `env`, replace with `valueFrom`, and add `secretKeyRef`
underneath
