# 3.5 - Authentication

- In general, there are two types of accounts available:
  - User accounts - Admins, developers, etc
  - Service accounts - machine-based accounts
- All access to Kubernetes is handled via the Kube-API Server
- Authentication Mechanisms Available in Kubernetes for the API Server:
  - Static Password File - Not recommended
  - Static Token File
  - Certificates
  - Identity Services (3rd Party services e.g. LDAT)
- Suppose you have the user details in a file, you can pass this file as an option for authentication in the kube-apiserver.service file adding the flag: `--basic-auth-file=user-details.csv`

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
```

- Restart the service / the server after the change is done.
- If the cluster is setup using Kubeadm, edit the yaml file and add the same options in a similar manner to:

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

- Kubernetes will automatically update the apiserver once the change is made
- To authenticate using the credentials specified in this manner run a curl command similar to: `curl -v -k https://master-node-ip:6443/api/v1/pods -u "username:password"`
- Could also have a token file, specify using --token-auth-file=user-details.csv in the
api server .service or yaml file as appropriate
  - **Note:** the token can also be included in the curl request via --header
`"Authorization: Bearer <TOKEN>"`
- **Note:** These are not recommended authentication mechanisms
  - Should consider a volume mount when providing the auth file in a kubeadm
setup
  - Setup RBAC for new users
- Could also setup RBAC using YAML files to create rolebindings for each user