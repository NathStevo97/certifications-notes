# 3.8 - Secrets

- Considering a simple python server:
- The hostname username and passwords are hardcoded in bad practice => high security risk.
- It would be better to store this data as a ConfigMap based on previous discussion - the problem though is that ConfigMap data is stored in a plaintext format.
  - Not applicable for sensitive info like passwords

- Variables like username and passwords are better stored as `secrets` in Kubernetes.
  - These are similar to ConfigMaps, but the values are stored in encrypted format.

- Analogous to ConfigMaps, there are 2 steps:
  - Secret Creation
  - Inject secrets to a pod.

- Secret creation is achieved either imperatively or declaratively:
  - **Declarative:** Use a YAML definition file to "declare" the desired configuration
  - **Imperative:** Use the `kubectl create secret` command to "imply" Kubernetes to create a secret, and let Kubernetes figure out the configuration desired.

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
- Create the secret via `kubectl create -f ....` as normal
- Secrets can be viewed via: `kubectl get secrets`
- Detailed information viewed via: `kubectl describe secrets <secret name>`

- To view secret in more detail: `kubectl get secret <secret name> -o yaml`

- To decode secret: `echo -n '<secret base64 value>' | base64 --decode`

## Secrets in Pods

- With both a pod and secret YAML file, the secret data can be injected as environment variables:

```yaml
spec:
  containers:
  - envFrom:
    - secretRef:
        name: <secret name>
```

- When `kubectl create -f ...` is run, the secret data is available as environment variables in the pod.

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

## Additional Notes

- Secrets are encoded in base64 format -> this can easily be decoded as they're not encrypted!
- It's thought that secrets are a safer option, but this is only in the sense that "it's better than plaintext".

- It's the practices regarding secret storage that makes them safer, including:
  - Not checking-in secret object definition files to source code repositories
  - Enabling encryption-at-rest for secrets

- Kubernetes takes some actions to ensure safe handling of secrets:
  - A secret is only sent to a node if a pod on said node requires it
  - Kubelet stores the secret into a temporary file storage so it's not persisted to a disk.
  - Once a pod is deleted, any local copies of secrets used by that pod are deleted.

- For further improved safety regarding secrets, one could also use tools such as Helm Secrets and HashiCorp Vault.

## Encrypting Secrets at Rest

- Additional guidance can be found in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
- Encryption at rest is determined by configuring the `kube-apiserver` and the etcd server.

### Secret Storage in ETCD

- Creating a sample secret in Kubernetes: `kubectl create secret generic secret1 -n default --from-literal=mykey=mydata`
- The secret can be read from `etcd` via the `etcdctl` utility:

```shell
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/secret1 | hexdump -C
```

- Without encryption at rest, the above command would return the secret value in plaintext format, this is a huge security risk.

### Enabling Encryption at Rest

- The `kube-apiserver` process accepts the flag `--encryption-provider-config` to determine API data encryption in ETCD.
- To check if it's enabled: `ps -aux | grep kube-api | grep "encryption-provider-config"` OR examine the `kube-apiserver.yaml` manifest for the same flag.
- If not enabled, one can define an `EncryptionConfiguration` YAML manifest to attach to this flag.
- An example (not suitable for production) from the documentation follows:

```yaml
---
#
# CAUTION: this is an example configuration.
#          Do not use this for your own cluster!
#
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
      - configmaps
      - pandas.awesome.bears.example # a custom resource API
    providers:
      # This configuration does not provide data confidentiality. The first
      # configured provider is specifying the "identity" mechanism, which
      # stores resources as plain text.
      #
      - identity: {} # plain text, in other words NO encryption
      - aesgcm:
          keys:
            - name: key1
              secret: c2VjcmV0IGlzIHNlY3VyZQ==
            - name: key2
              secret: dGhpcyBpcyBwYXNzd29yZA==
      - aescbc:
          keys:
            - name: key1
              secret: c2VjcmV0IGlzIHNlY3VyZQ==
            - name: key2
              secret: dGhpcyBpcyBwYXNzd29yZA==
      - secretbox:
          keys:
            - name: key1
              secret: YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY=
  - resources:
      - events
    providers:
      - identity: {} # do not encrypt Events even though *.* is specified below
  - resources:
      - '*.apps' # wildcard match requires Kubernetes 1.27 or later
    providers:
      - aescbc:
          keys:
          - name: key2
            secret: c2VjcmV0IGlzIHNlY3VyZSwgb3IgaXMgaXQ/Cg==
  - resources:
      - '*.*' # wildcard match requires Kubernetes 1.27 or later
    providers:
      - aescbc:
          keys:
          - name: key3
            secret: c2VjcmV0IGlzIHNlY3VyZSwgSSB0aGluaw==
```

- As per usual, the first 2 lines determine the `apiVersion` and `kind`. From here, the general format is to list in arrays the `resources` and the `provider(s)` to be used in association with encryption and decryption.
- Under `providers`, the first provider is for encryption **only**, any providers listed after that for the given resources are suitable for decryption **only**.
- There are multiple providers available, such as `identity` (no encryption), `kms`, `secretbox`, etc.

- Creating an example encryption configuration file, which leverages the `aesbc` encryption provider:

```yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
      - configmaps
      - pandas.awesome.bears.example
    providers:
      - aescbc:
          keys:
            - name: key1
              # See the following text for more details about the secret value
              secret: <BASE 64 ENCODED SECRET>
      - identity: {} # this fallback allows reading unencrypted secrets;
                     # for example, during initial migration
```

- The secret for the `aescbc` provider can be a random 32-byte key encoded in base64 - `head -c 32 /dev/urandom | base64`.
- Saving the encryption config file to a given path, it will then need to be mounted to the `kube-apiserver` static pod, achieved by editing the `kube-apiserver` manifest, adding the `--encryption-provider-config=/path/to/config` flag, and mounting the config's location as a volume.

```yaml
---
#
# This is a fragment of a manifest for a static Pod.
# Check whether this is correct for your cluster and for your API server.
#
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 10.20.30.40:443
  creationTimestamp: null
  labels:
    app.kubernetes.io/component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    ...
    - --encryption-provider-config=/etc/kubernetes/enc/enc.yaml  # add this line
    volumeMounts:
    ...
    - name: enc                           # add this line
      mountPath: /etc/kubernetes/enc      # add this line
      readOnly: true                      # add this line
    ...
  volumes:
  ...
  - name: enc                             # add this line
    hostPath:                             # add this line
      path: /etc/kubernetes/enc           # add this line
      type: DirectoryOrCreate             # add this line
  ...
```

- As a static pod is being edited, the API Server should restart automatically, if it fails to do so, troubleshoot accordingly.
- These steps should be repeated per control plane node, and for verification, the original steps with `etcdctl` can be repeated.
- Note: To ensure all relevant data is encrypted, including that which is already stored, run the following command to update them with the relevant config as an administrator: `kubectl get secrets --all-namespaces -o json | kubectl replace -f -`
