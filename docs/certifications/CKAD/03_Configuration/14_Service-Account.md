# 3.14 - Service Account

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

## Service Accounts Updates - 1.22/1.24

- All namespaces have a default service account with its own secret, when a pod is created, this service account is automatically associated with the pod, and the secret is mounted to a given location.
- As a result of this, a process within the pod can query the Kubernetes API using the mounted token.
- Checking the location where the secret is mounted, three files are found:
  - `ca.crt`
  - `namespace`
  - `token` - the ServiceAccount token.
- The token can be decoded via `jq` (or some other means e.g. jwt.io) via the following command: `jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< < TOKEN>`
- The output shows that the token has no expiry date defined in the payload section - this poses problems.

### v1.22 Notes on Bound Service Account Tokens

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

### v1.24 Enhancements

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
