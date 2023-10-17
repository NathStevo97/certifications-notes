# 5.2 - Admission Controllers

- Commands are typically ran using the kubectl utility, these commands are sent to the kubeapi server and applied accordingly
  - To determine the validity of the command, it goes through an authentication process via certificates
  - Any kubectl commands come from users with a kubeconfig file containing
the certificates required
  - The determination of whether the process has permission to carry the task out is handled by RBAC authorization
    - Kubernetes Roles are used to support this.
- With RBAC, restrictions can be placed on resources for:
  - Operation-wide restrictions
  - Specific operation restrictions e.g. create pod of specific names
  - Namespace-scoped restrictions
- What happens if you want to go beyond this? For example:
  - Allow images from a specific registry
  - Only run as a particular user
  - Allow specific capabilities
  - Constrain the metadata to include specific information
- The above is handled by **Admission controllers**
  - Various pre-built admission controllers come with K8s:
    - AlwaysPullImages
    - DefaultStorageClass
    - EventRateLimit
    - NamespaceExists
- Example - NamespaceExists:
  - If creating a pod in a namespace that doesn't exist:
    - The request is authenticated and authorized
    - The request is then denied as the admission controller acknowledges that the namespace doesn't exist -> Request is denied
- To view admission controllers enabled by default: `kube-apiserver -h | grep enable-admission-plugins`
  - **Note:** For kubeadm setups, this must be run from the kube-apiserver control plane using kubectl

- Admission controllers can either be added to the .service file or the .yaml manifest depending on the setup:

```shell
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --enable-swagger-ui=true \\
  --etcd-servers=https://127.0.0.1:2379 \\
  --event-ttl=1h \\
  --runtime-configmap=api/all \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --v=2
  --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
```

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
    image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
    name: kube-apiserver
```

- To disable a plugin use `--disable-admission-plugins=<plugin1>,<plugin2>, ....`
- **Note:** NamespaceAutoProvision is not enabled by default - it can be enabled by the
above menthods
