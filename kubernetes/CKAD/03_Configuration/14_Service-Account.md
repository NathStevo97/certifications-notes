# 3.14 - Service Account

- A service account links to securty concepts such as authorisation and RBAC, etc.
- One of 2 account types in Kubernetes, the other being a user account:
  - User accounts are used by humans e.g. development accounts.
  - Service accounts are those used by applications to interact with Kubernetes.

- For an app to use/interact with the Kubernetes API, it needs to authenticate via service accounts.

- Creation via: `kubectl create serviceaccount <serviceaccount name>`
- View service accounts via `kubectl get serviceaccount`
- When a serviceaccount is created, it automatically creates a service token to be used for authentication.

- Token can be viewed (along with other details) via `kubectl describe serviceaccount <serviceaccount name>`
- Token is stored as a kubernetes secret by default, it can be viewed via `kubectl describe secret <secret ID>`

- Suppose the app using the service account is already part of a Kubernetes cluster.
  - One can mount the service token secret as a volume inside the pod
  - This allows it to be easily accessible by the application

- The default service account and its corresponding token is automatically mounted as a volume to the pod.
- In the path of the mount, 3 files are stored, detailing:
  - Namespace
  - Token
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
