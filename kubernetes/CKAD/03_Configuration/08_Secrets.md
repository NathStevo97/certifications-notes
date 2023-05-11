# 3.8 - Secrets

- Considering a simple python server:
- The hostname username and passwords are hardcoded in bad practice => high security risk.
- It would be better to store this data as a ConfigMap based on previous discussion - the problem though is that ConfigMap data is stored in a plaintext format.
  - Not applicable for sensitive info like passwords

- Variables like username and passwords are better stored as `secrets` in Kubernetes.
  - These are similar to ConfigMaps, but the values are stored in encrypted format.

- Analagous to ConfigMaps, there are 2 steps:
  - Secret Creation
  - Inject secrets to a pod.

- Secret creation is achieved either imperatively or declaratively:
  - **Declarative:** Use a YAML definition file to "declare" the desired configuration
  - **Imperative:** Use the `kubectl create secret` command to "imply" Kubernetes to create a secret, and let Kubernetes figure out / guestimate the configuration desired.

## Imperative Secret Creation

- `kubectl create secret generic <secret name> --from-literal=<key>=<value>`

- As with ConfigMaps, data can be specified from the CLI in key-value-pairs via the `--from-literal` flag multiple times.

- Example: `kubectl create secret generic app-secret --from-literal=DB_HOST=mysql --from-literal=DB_USER=root --from-literal=DB_PASSWORD=password`

- For larger amounts of secrets, the data can be imported from a file, achieved by using the `--from-file` flag.

- Example: `kubectl create secret generic app-secret --from-file=app-secret.properties`

## Declarative Secret Creation

- Using a YAML definition file:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_HOST: mysql
  DB_USER: root
  DB_PASSWORD: password
```

- As discussed, the secrets should not be stored in plaintext string format. Typically, Kubernetes secrets are stored in Base64 encrypted format.
- To convert: `echo -n '<secret plaintext value>' | base64`
- Create the secret via `kubectl create -f .... ` as normal
- Secrets can be viewed via: `kubectl get secrets`
- Detailed information viewed via: `kubectl describe secrets <secret name>`

- To view secret in more detail: `kubectl get secret <secret name> -o yaml`

- To decode secret: ` echo -n '<secret base64 value>' | base64 --decode`

## Secrets in Pods

- With both a pod and secret YAML file, the secret data can be injected as environment variables:

```yaml
spec:
  containers:
  - envFrom:
    - secretRef:
        name: <secret name>
```

- When `kubectl create -f ... ` is run, the secret data is available as environment variables in the pod.

- As before, one can inject secrets to pods via environment variables (above) OR a single environment variable (below):

```yaml
spec:
  containers:
  - env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: DB_PASSWORD
```

## Secrets in Volumes

- Secrets can also be added as volumes attached to pods:

```yaml
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```

- If mounting the secret as a volume, each attribute in the secret is created as a file, with the value being the content.