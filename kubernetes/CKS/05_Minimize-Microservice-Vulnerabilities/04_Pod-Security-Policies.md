# 5.4 - Pod Security Policies

- When developing pods, there may be configurations you wish to prevent users from using / applying on the cluster
  - Examples:
    - Prevent container from having root access to the underlying system
    - Prevent running as root user
    - Prevent certain capabilities
  - These restrictions can be enforced by Pod Security Policies
- There is a pod security policy Admission controller that comes as part of Kubernetes
by default, though it is not enabled by default.
  - Check if disabled by:: `kube-apiserver -h | grep enable-admission-plugins`
- It can be enabled by updating the `--enable-admission-plugins` flag with the `kube-apiserver.service` or `kube-apiserver.yaml` files:

```yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --authorization-mode=Node,RBAC
    - --advertise-address=172.17.0.107
    - --allow-privileged=true
    - --enabke-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
    - --enable-admission-plugins=PodSecurityPolicy
    image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
    name: kube-apiserver
```

- Once enabled, one can create a Pod Security Policy Object, outlining the requirements / restrictions. An example of restricting running as privileged user follows:

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: example-psp
spec:
  privileged: false
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
```

- **Note:**
  - seLinux, supplementalGroups, runAsUser and fsGroup are all mandatory fields.
- Once deployed, any pod definition files will be checked against the pod security policy.
- **Note:** Need to ensure that the security policy api must be authenticated / authorized for the admission controller to work.
  - This can be achieved via RBAC
  - Every pod has a serviceAccount associated with it (default if not specified)
    - Can therefore create a role and bind the serviceAccount to allow
access to the pod security policy api

```yaml
# psp-example-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: psp-example-role
rules:
- apiGroups: ["policy"]
  resources: ["podsecuritypolicies"]
  resourceNames: ["example-psp"]
  verbs: ["use"]
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: psp-example-rolebinding
subjects:
- kind: ServiceAccount
  name: default
  neamespace: default
roleRef:
  kind: Role
  name: psp-example-role
  apiGroup: rbac.authorization.k8s.io
```

- In Pod Security Policies, one can:
  - Force the user to run as "non-root"
  - Force capabilities to be added or removed
  - Restrict the types of volumes