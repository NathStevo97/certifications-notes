# 3.0 - Configuration

## 3.1 - Prerequisites: Commands and Arguments in Docker

- **Note:** This is not a requirement for the CKAN curriculum.

- Consider a simple scenario:
  - Run a docker container via an ubuntu image: `docker run ubuntu`
  - Runs an instance of the Ubuntu image and exits immediately, noted upon execution of `docker ps -a`

- This occurs because containers aren't designed to host an OS, but instead to run a specific task or process.
  - Example: host a web server or database
  - So long as that process stays active, so does the container.
  - If the service stops or crashes, the container exits.

- A Dockerfile with `CMD ["bash"]` defined doesn't work as this is not a command, but a CLI instead.
  - When the container runs, it runs Ubuntu and launches bash
- In general, Docker doesn't attach a terminal to a container when it's ran.
  - Bash cannot find a terminal and the container exits as the process finishes/fails.

- To solve, one can append commands to the `docker run` command e.g. <br> `docker run ubuntu sleep 5`

- Similarly, in a Dockerfile <br> `CMD <command> <param1>` <br> or in JSON: <br> `CMD ["command", "parameter"]`

- To build new image and run: `docker build -t <image name> .`
- To run: `docker run <image name>`

- To use the command but with a parameter value subject to change, change `CMD` to `ENTRYPOINT` i.e.: <br> `ENTRYPOINT ["command"]`
  - Any parameters specified on the CLI will automatically be appended to the entrypoint command.

- If using entrpoint and a command parameter isn't specified, an error is likely to occur, a default value should therefore be provided.
  - Therefore, `ENTRYPOINT` and `CMD` should be used together.

- Example:

```dockerfile
ENTRYPOINT ["command"]

CMD ["parameter"]
```

- From this configuration, if no additional parameter(s) is provided, the `CMD` parameter will be provided.
- Any parameter on the CLI will override the `CMD` parameter

- To override the entrypoint: `docker run --entrypoint <new command> <image name>`

- Note: `ENTRYPOINT` and `CMD` values should be expressed in a JSON format.

## 3.2 - Commands and Arguments in Kubernetes

- The Ubuntu sleeper image can be defined in a YAML file for Kubernetes similar to the following:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <pod name>
spec:
  containers:
  - name: <container name>
    image: <image name>:<image tag>
    command: ["<command>"]
    args: ["<arg1>"]
```

- To add anything to be appended to the `docker run` command, one adds the a`args` attribute to the container spec.
- The pod can then be created through standard means such as `kubectl create -f <filenmame>.yaml`
- The Dockerfile's entrypoint is overwritten by the `command` atribute.

- **Note:** You cannot edit specifications of a pre-existing pod aside from:
  - `containers`
  - `initContainers`
  - `activeDeadlineSections`
  - `tolerations`

- Environmental variables, in general, cannot be edited, as well as service accounts and resource limits.
- If editing is required of these parameters, 2 methods are advised:
  1. `kubectl edit pod <pod name>`
      - Edit the properties desired
      - As outlined above, certain properties cannot be edited whilst a pod is "live" - if this happens, the requested changes to the YAML will be saved as a temporary definition.
      - Delete the original pod `kubectl delete pod <pod name>`
      - Recreate the pod from the temp definition file: `kubectl create -f <temp filename>.yaml`
  2. Extract the YAML of the pod via `kubectl get pod <pod name> -o yaml > <file name>.yaml`
     - Open the extracted YAML and edit as appropriate e.g. `vim <filename>.yaml`
     - Delete the original pod and recreate similar to the latter 2 steps of method 1.

- **Note:** If part of a deployment, change any instance of `pod` in the commands above to `deployment`.
- Any changes to deployments are automatically applied to the pods within.

## 3.5 - Environment Variables

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

## 3.6 - ConfigMaps

- When there are multiple pod definition files, it becomes difficult to manage environment data.
- This information can be removed from the definition files and managed centrally via ConfigMaps
- Used to pass configuration data as key-value pairs in Kubernetes
- When a pod is created, one can inject the ConfigMap into the pod.
  - The key-value pairs are available to the pod as environment variables for the application within the pod.

- Configuring ConfigMaps involves 2 phases:
  - Create the ConfigMap
  - Inject it to the pod.

- Creation is achieved through standard means: `kubectl create configmap <configmap name>`
- Or if a YAML file exists: `kubectl create -f <filename>.yaml`

- Via the first method, one can automatically pass in key-value pairs: <br>
  `kubectl create configmap <configmap name> --from-literal=<key>=<value> --from-literal=<key2>=<value2>`

- Multiple uses of the `--from-literal=<key>=<value>` allows multiple variables to be added.
  - **Note:** This becomes difficult when too many config items are present.
- One can also create ConfigMaps from a file e.g. <br> `kubectl create configmap <configmap name> --from-file=/path/to/file`

### Creating a ConfigMap via Declaration

- Create a definition file:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```

- To create from the above: `kubectl create -f <filename>.yaml`

- Can create as many ConfigMaps and required, just ensure they are named appropriately.

- View ConfigMaps via `kubectl get configmaps`
- Get detailed information of a ConfigMap via `kubectl describe configmap <configmap name>`

- Configuring a pod with a ConfigMap:
  - In a pod definition file, under the containers in spec, add `envFrom:` list property.
  - Each item in the resultant list corresponds to a ConfigMap item.

- Example usage:

```yaml
envFrom:
- configMapRef:
    name: app-config
```

- Can apply the config file and pod definitions with the `kubectl create -f <pod definition>.yaml`

### Summary

- ConfigMaps can be used to inject environmental variables into pods
- Could also inject the data as a file or via a volume

#### env

```yaml
envFrom:
- configMapRef:
    name: <configmap key name>
```

#### single env

```yaml
env:
- name: <env name>
  valueFrom:
    configMapKeyRef:
      name: <configmap name>
      key: <configmap key name>
```

#### Volumes

```yaml
volumes:
- name: app-config-volume
  configMap:
    name: app-config
```

## 3.8 - Secrets

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

### Imperative Secret Creation

- `kubectl create secret generic <secret name> --from-literal=<key>=<value>`

- As with ConfigMaps, data can be specified from the CLI in key-value-pairs via the `--from-literal` flag multiple times.

- Example: `kubectl create secret generic app-secret --from-literal=DB_HOST=mysql --from-literal=DB_USER=root --from-literal=DB_PASSWORD=password`

- For larger amounts of secrets, the data can be imported from a file, achieved by using the `--from-file` flag.

- Example: `kubectl create secret generic app-secret --from-file=app-secret.properties`

### Declarative Secret Creation

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

### Secrets in Pods

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

### Secrets in Volumes

- Secrets can also be added as volumes attached to pods:

```yaml
volumes:
- name: app-secret-volume
  secret:
    secretName: app-secret
```

- If mounting the secret as a volume, each attribute in the secret is created as a file, with the value being the content.

### Additional Notes

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

### Encrypting Secrets at Rest

- Additional guidance can be found in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
- Encryption at rest is determined by configuring the `kube-apiserver` and the etcd server.

#### Secret Storage in ETCD

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

#### Enabling Encryption at Rest

- The `kube-apiserver` process accepts the flag `--encryption-provider-config` to determine API data encryption in ETCD.
- To check if it's enabled: `ps -aux | grep kube-api | grep "encryption-provider-config"` OR examine the `kube-apiserver.yaml` manifest for the same flag.
- If not enabled, one can define an `EncryptionConfiguration` YAML manifest to attach to this flag.
- An example (not suitable for production) from the documentation follows:

```yaml
---
##
## CAUTION: this is an example configuration.
##          Do not use this for your own cluster!
##
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
##
## This is a fragment of a manifest for a static Pod.
## Check whether this is correct for your cluster and for your API server.
##
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

## 3.11 - Docker Security

- Consider a host with Docker running on it.
  - The host will be running processes such as the Docker Daemon
- Containers aren't completely isolated from their host -> they share the same kernel
- In general, containers are separated by namespaces (Linux)
- All processes run by a container are run by the host, just in their own namespace
  - The container can only see its own process via `ps aux`

- In the host, all processes are visible, container processes have differing IDs depending on their namespace

### Security: Users

- Docker hosts can have root users as well as non-root users
- By default, Docker runs processes in containers as the root user.
  - True within and outside the container

- To edit the default user for the container, use `docker run` in a similar manner to: `docker run --user=<username> <container> <command>`

- To enforce security, one can add `USER` value to the Dockerfile e.g. `USER 1000`
  - This automatically defines the user when the container is built and run.
- When running a container that defaults to the root user, Docker takes measures to prevent the root user from taking unnecessary actions via Linux Capabilities.

### Linux Capabilities

- Listed in `/usr/include/linux/capability.h`
- In containers, Docker applies limited capabilities by default
- To override, add `--cap-add <CAPABILITY NAME>` to the `docker run` command
- To remove: `--cap-drop <CAPABILITY NAME>` in a similar manner
- For all capabilities, add `--privileged` -> not recommended!

## 3.12 - Security Contexts

- Container security may be configured by adding or specifying users and their associated capabilities in the `docker run` command.
- Similar settings may also be handled via Kubernetes.

- As containers are hosted within pods on Kubernetes, one can either configure security at the pod or container level.
  - If configured at pod level, any changes will automatically be applied to the containers within.
  - If configured at container level, these settings will override anything defined at pod level.

### Security Context

- To configure security in the definition file, add the `securityContext:` attribute
- User is set by `runAsUser: <user ID>`
- To configure at container-level, add the same fields to the containers list
- To add capabilities, add `capabilities:`, then in a dictionary, add `add: ["<CAPABILITY ID>", .... ]`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod
spec:
  #securityContext:
  #    runAsUser: 1000
  containers:
  - name: ubuntu
    image: ubuntu
    command: ["sleep", "3600"]
    securityContext:
      runAsUser: 1000
      capabilities:
        add: ["MAC_ADMIN"]
```

- **Note:** Capabilities are only supported at container-level, not pod-level.

## 3.14 - Service Account

- A service account links to securIty concepts such as authorization and RBAC, etc.
- One of 2 account types in Kubernetes, the other being a user account:
  - User accounts are used by humans e.g. development accounts.
  - Service accounts are those used by applications to interact with Kubernetes.

- For an app to use/interact with the Kubernetes API, it needs to authenticate via service accounts.

- Creation via: `kubectl create serviceaccount <serviceaccount name>`
- View service accounts via `kubectl get serviceaccount`
- When a `serviceaccount`` is created, it automatically creates a service token to be used for authentication.

- Token can be viewed (along with other details) via `kubectl describe serviceaccount <serviceaccount name>`
- Token is stored as a Kubernetes secret by default, it can be viewed via `kubectl describe secret <secret ID>`

- Suppose the app using the service account is already part of a Kubernetes cluster.
  - One can mount the service token secret as a volume inside the pod
  - This allows it to be easily accessible by the application

- The default service account and its corresponding token is automatically mounted as a volume to the pod.
- In the path of the mount, 3 files are stored, detailing:
  - `Namespace`
  - `Token`
  - `ca.crt`
- The above can be viewed for a given service by `kubectl exec -it <service id> ls /var/run/secrets/kubernetes.io/<serviceaccount>`

- **Note:** The default service account is restricted to basic operations.
  - Automatically created and mounted.
  - If you wish to switch it, edit the pod definition file to add `serviceAccount:` under the `spec:`, then delete and recreate the pod.
  - Changes like this are automatically applied if editing a deployment.

- **Note:** One can avoid automatic service account association via the addition of `automountServiceAccountToken: false`

- Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: build-robot
  automountServiceAccountToken: false
```

### Service Accounts Updates - 1.22/1.24

- All namespaces have a default service account with its own secret, when a pod is created, this service account is automatically associated with the pod, and the secret is mounted to a given location.
- As a result of this, a process within the pod can query the Kubernetes API using the mounted token.
- Checking the location where the secret is mounted, three files are found:
  - `ca.crt`
  - `namespace`
  - `token` - the ServiceAccount token.
- The token can be decoded via `jq` (or some other means e.g. jwt.io) via the following command: `jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< < TOKEN>`
- The output shows that the token has no expiry date defined in the payload section - this poses problems.

#### v1.22 Notes on Bound Service Account Tokens

- Kubernetes already provisions JWTs to workloads, a functionality that is enabled by default, and therefore widely deployed - leading to the following problems:

1. These JWTs are not audience-bound -> Anyone with the JWT can pretend to be an authenticated user
2. The current model of storing the service account token in a secret delivered to nodes provides a large attack surface to the control plane nodes.
3. The JWTs are not time-bound, any JWT Compromised via the previous 2 points are valid so long as the service account exists.
4. Each JWT requires a Kubernetes secret -> Not Scalable

- To overcome this, the `TokenRequestAPI` was introduced, this generates tokens which are Audience, Time and Object bound.
- Since its introduction, when a new pod is created, it no longer requires on the token from the service account, instead, a token with a particular lifetime is created by the TokenRequestAPI via the ServiceAccount Admission controller.
  - This token is then mounted as a projected volume into the pod.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: default
spec:
  containers:
  - image: nginx
    name: nginx
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-<random string>
  volumes:
  - name: kube-api-access-<random string>
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downnwardAPI:
          items:
          - fieldRed:
              apiVersion: v1
```

#### v1.24 Enhancements

- This version included changes to reduce the amount of secret-based service account tokens.
- Previously, upon `serviceaccount` creation, a secret token that had no expiry and was unbound, was automatically created and mounted into pods upon their creation.
- In `v1.24`, the `serviceaccount` token creation is no longer automatic, instead it must be created separately after serviceaccount creation i.e.:
  - `kubectl create serviceaccount <serviceaccount name>`
  - `kubectl create token <serviceaccount name>`
- If this token is decoded via means defined previously, an expiry date can be seen in the payload.
- The secrets can still be created with no expiry if desired, however this is REALLY not advised:

```yaml
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: <secret name>
  annotations:
    kubernetes.io/service-account.name: <service account name>
```

## 3.17 - Resource Requirements

- Consider a 3-node setup, each has a set amount of resources available i.e.:
  - CPU
  - Memory
  - Disk Space

- The Kubernetes scheduler is responsible for allocating pods to nodes
  - To do so, it takes into account the node's current resource allocation and the resources requested by the pod.
  - If no resources are available, the scheduler will hold the pod back for release
- Kubernetes automatically assumes a pod or container within a pod will require at least:
  - `0.5` CPU Units
  - `256Mi` Memory

- If the pod or container requires more resources than allocated above, one can configure the pod definition file's spec, in particular, add the following under the `containers` list:

```yaml
resources:
  requests:
    memory: "1Gi"
    cpu: 1
```

### Resource - CPU

- Can be set from `1m` (1 micro) to as high as required / supported by the host system.
- 1 CPU = 1 AWS vCPU = 1 GCP Core = 1 Azure Core = 1 Hyperthread

### Resources - Memory

- Allocate within any of the following suffix for the givne purpose and the system's capabilities:

| Memory Metric | Shorthand Notation | Equivalency |
| ------------- | ------------------ | ----------- |
| Gigagbyte     | G                  | 1000M       |
| Megabyte      | M                  | 1000K       |
| Kilobyte      | K                  | 1000 Bytes  |
| Gigibyte      | Gi                 | 1024Mi      |
| Mebibyte      | Mi                 | 1024Ki      |
| Kilibyte      | Ki                 | 1024 Bytes  |

- Docker containers have no limit to the resources they can consume
- When only running on a node, it can only use a maximum of 1vCPU unit - if the limits need changing, update the pod definition file:

```yaml
resources:
  requests:
    memory: <value and unit>
    cpu: <value and limit>
    ....
  limits:
    memory: < value and unit>
    cpu: <number>
```

- The limits and requests can be set for each pod and container
- If CPU overload occurs, CPU usage is "throttled" on the node so it does not go beyond the limit.
- If repeated memory use is exceeded for an extended period of time, the pod is terminated with an `OOM` (Out of Memory) error.

### Default Behavior

- By default, Kubernetes doesn't set CPU or Memory limits, pods would be able to use as much of these resources as they like until it stops other pods from functioning.

- Rather than just putting blanket limits or requests in place, it's often advised to tailor the requests and limits per workload.
- Alternatively, you could put in requests without limits, ensuring that each pod is guaranteed the minimum resources required, but this doesn't prevent resource quota throttling.

#### Limit Ranges

- To ensure all pods are created with particular limits by default, one can create a `LimitRange` object, both CPU and Memory constraints can be defined by a single LimitRange:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
spec:
  limits:
  - default:
      cpu: 500m
    defaultRequest:
      cpu: 500m
    max:
      cpu: "1"
    min:
      cpu: 100m
    type: Container
```

- Quotas can be set for a namespace itself by creating a `ResourceQuota` object - these are namespace-scoped:

```yaml
apiVersion: v1
kind:  ResourceQuota
metadata:
  name: my-resource-quota
spec:
  hard:
    requests.cpu: 4
    requests.memory: 4Gi
    limits.cpu: 10
    limits.memory: 10Gi
```

## 3.19 - Taints and Tolerations

- Used to set restrictions regarding what pods can be scheduled on a node.
- Consider a cluster of 3 nodes with 4 pods preparing for launch:
  - The scheduler will place the pods across all nodes equally if no restriction applies

- Suppose now only 1 node has resources available to run a particular application:
  - A taint can be applied to the node in question; preventing any unwanted pods from being scheduled on it.
  - Tolerations then need to be applied to the pod(s) to specifically run on node 1

- Pods can only run on a node if their tolerations match the taint applied to the node.

- Taints and tolerations allow the scheduler to allocate pods to required nodes, such that all resources are used and allocated accordingly.

- **Note:** By default, no tolerations are applied to pods.

### Taints - Node

- To apply a taint: `kubectl taint nodes <nodename> key=value:<taint-effect>`
- The key-value pair defined could match labels defined for resources e.g `app=frontend`
- The taint effect determines what happens to pods that are intolerant to the taint, 1 of 3 possibilities can be specified:
  - `NoSchedule` - Pods won't be scheduled.
  - `PreferNoSchedule` - Try to avoid scheduling if possible.
  - `NoExecute` - New pods won't be scheduled, and any pre-existing pods intolerant to the taint are stopped and evicted.

### Tolerations - Pod

- To apply a toleration to a pod, one can look at the definition file
- In the spec section, add similar to the following:

```yaml
...
spec:
  containers:
  ...
  tolerations:
  - key: app
    operator: "Equal"
    value: "blue"
    effect: "NoSchedule"
```

- Be sure to apply the same values used when applying the taint to the node.
- All values added need to be enclosed in " ".

### Taint - NoExecute

- Suppose Node1 is to be used for a particular application:
  - Apply a taint to node 1 with the app name and add a toleration to the pod running the app.
  - Setting the taint effect to `NoExecute` causes existing pods on the node that are intolerant to be stopped and evicted.

- Taints and tolerations are only used to restrict pod access to nodes.
- As there are no restrictions / taints applied to the other pods, there's a chance the app could still be placed on a different node(s).
- If wanting the pod to go to a particular node, one can utilize node affinity.

- **Note:** A taint is automatically applied to the master node, such that no pods can be scheduled to it.
  - View it via `kubectl describe node kubemaster | grep Taint`

## 3.20 - Node Selectors

- Consider a 3-node cluster, with 1 node having a larger resource configuration:
  - In this scenario, one would like the task/process requiring more resources to go to the larger node.
- To solve, can place limitations on pods
- This can be done via the `nodeSelector` property in the definition file:

```yaml
nodeSelector:
  size: node-label
```

- NodeSelectors require the node to be labelled: `kubectl label nodes <node name> <label key>=<key value>`

- When pod is created, it should be assigned to the labelled node so long as the resources allow it.

### Limitations of NodeSelectors

- NodeSelectors are beneficial for simple allocation tasks, but if more complex allocation is needed, Node Affinity is recommended, e.g. "go to either 1 of 2 nodes".

## 3.22 - Node Affinity

- Node affinity looks to ensure that pods are hosted on the desired nodes
- Can ensure high-resource consumption jobs are allocated to high-resource nodes

- Node affinity allows more complex capabilities regarding pod-node limitation.

- To specify, in the spec section of a pod definition file add in a new field:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      matchExpressions:
      - key: size
        operator: In
        values:
        - Large
```

- **Note:** For the example above, the `NotIn` operator could also be used to avoid particular nodes.
- **Note:** If just needing a pod to go to any node with a particular label, regardless of value, use the `Exists` operator -> no values are required in this case.

- Additional operators are available, with further details provided in the documentation.
- In the event that a node cannot be allocated due to a label fault, the resulting action is dependent upon the NodeAffinityType set.

### Node Affinity Types

- Defines the scheduler's behavior regarding Node Affinity and pod lifecycle stages

- 2 main types available:
  1. `RequireDuringSchedulingIgnoredDuringExecution`
  1. `PreferredDuringSchedulingIgnoredDuringExecution`

- Other types are to be released such as `requiredDuringSchedulingRequiredDuringExecution`

- Considering the 2 available types, can break it down into the 2 stages of a pod lifecycle:
  1. **DuringScheduling** -> The pod has been created for the first time and not deployed
  2. **DuringExecution**

- If the node isn't available according to the NodeAffinity, the resultant action is dependent upon the NodeAffinity type:

- **Required:**
  - Pod must be placed on a node that satisfies the node affinity criteria
  - If no node satisfies the criteria, the pod won't be scheduled
  - Generally used when the node placement is crucial

- **Preferred:**
  - Used if the pod placement is less important than the need for running the task
  - If a matching node not found, the scheduler ignores the NodeAffinity
  - Pod placed on any available node

- Suppose a pod has been running and a change is made to the Node Affinity:
  - The response is determined by the prefix of `DuringExecution`:
    - **Ignored:**
      - Pods continue to run
      - Any changes in Node Affinity will have no effect once scheduled.
    - **Required:**
      - When applied, if any current pods that don't meet the NodeAffinity requirements are evicted.

### Taints and Tolerations vs Node Affinity

- Consider a 5-cluster setup:
  - Blue Node: Runs the blue pod
  - Red Node: Runs the red pod
  - Green Node: runs the green pod
  - Node 1: To run the grey pod
  - Node 2: " "

- Applying a taint to each of the colored nodes to accept their respective pod
  - Tolerances are then are applied to the pods

- Need to apply a taint to node 1 and node 2 as the colored pods can still be allocated to nodes where they're not wanted.

- To overcome, use **Node Affinity**:
  - Label nodes with respective colors
  - Pods end up in the correct nodes via use of Node Selector.

- There's a chance that the unwanted pods could still be allocated e.g. the grey pods could still be scheduled on the colored nodes.

- A combination of taints and tolerations, and node affinity must be used.
  - Apply taints and tolerations to present unwanted pod placement on nodes
  - Use node affinity to prevent the correct pods from being placed on incorrect nodes.
