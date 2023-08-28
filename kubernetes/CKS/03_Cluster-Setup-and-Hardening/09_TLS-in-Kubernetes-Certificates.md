# 3.9 - TLS In Kubernets: Certificates

- Tools available for certificate creation include:
  - EASYRSA
  - OPENSSL - The more common one (used in this example)
  - CFSSL
- **Steps - Server Certificates: CA Example**
  - Generate the private key: openssl genrsa -out ca.key 2048
    - The number "2048" in the above command indicates the size of the private key. You can choose one of five sizes: 512, 758, 1024, 1536 or 2048 (these numbers represent bits). The larger sizes offer greater security, but this is offset by a penalty in CPU performance. We recommend the best practice size of 1024.
  - Generate certificate signing request: `openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr`
  - **Note:** `"/CN=<NAME>"` outlines the name of the component the certificate is for.
  - Sign certificates, this is self-signed via the ca key pair: `openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt`
    - Results in CA having a private key and root certificate file
- **Client Certificate Generation Steps: Admin User Example**
  - Generate the keys: `openssl genrsa -out admin.key 2048`
  - Generate certificate signing request: `openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr`
  - Sign the certificate: `openssl x509 -req -in admin.csr -CAkey ca.key -out admin.crt`
    - The CA key pair is used for signing the new certificate, thus proving its validity
- When the admin user attempts to authenticate to the cluster, it is the certificate **admin.crt** that will be used for this
- For **non-admin users**, need to add group details to the certificate signing request to signal this.
  - Group called SYSTEM:MASTERS has administrative privileges, to specify this for an admin user, the signing request should be like: `openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr`
- The same procedure would be followed for client certificates for the **Scheduler**, **Controller-Manager** and **Kubelet** - prefix with SYSTEM
- The certificates generated could be applied in different scenarios:
  - Could use the certificate instead of usernames and password in a REST API call to the api server (via a **curl** request)
    - To do so, specify the key and the certs involved as options following the request e.g. `--key admin.key`, `--cert admin.crt`, and `--cacert ca.crt`
  - Alternatively, all the parameters could be moved to the kube config yaml file, which acts as a centralized location to reference the certificates
- **Note:** For each of the Kubernetes components to verify one another, they need a copy of the CA's root certificate
- **Server Certificate Example: ETCD Server**
  - As ETCD server can be deployed as a cluster across multiple servers, you must secure communication between the cluster members, or peers as they're commonly known as
  - Once generated, specify the certificates when starting the server
  - In the etcd yaml file, there are options to specify the peer certificates

```yaml
- etcd
  - --advertise-client-urls=https://127.0.0.1:2379
  - --key-file=/path-to-certs/etcdserver.key
  - --cert-file=/path-to-certs/etcdserver.crt
  - --client-cert-auth=true
  - --data-dir=/var/lib/etcd
  - --initial-advertise-peer-urls=https://127.0.0.1:2380
  - --initial-cluster=master=https://127.0.0.1:2380
  - --listen-client-urls=https://127.0.0.1:2379
  - --listen-peer-urls=https://127.0.0.1:2380
  - --name=master
  - --peer-cert-file=/path-to-certs/etcdpeer1.crt
  - --peer-client-cert-auth=true
  - --peer-key-file=/etc/kubernetes/pki/etc/peer.key
  - --peer-truster-ca-file=/etc/kubernetes/pki/etcd/ca.crt
  - --snapshot-count=10000
  - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
```

- **Server Certificate Example: API Server**
  - Same procedure involved, but due to the nature of the API Server, with essentially every operation running via it, and it being referred to by multiple names, requires a lot more information included; requiring an **openssl config file**
    - Using the config file, specify DNS and IP aliases for the components
      - Acceptable names:
        - `kubernetes`
        - `kubernetes.default`
        - `kubernetes.default.svc`
        - `kubernetes.default.svc.cluster.local`
    - When generating the signing request, you can reference the config file by appending: `--config <config name>.cnf` to the signing request command
    - From this, the certificate can be signed using the ca.crt and ca.key file as normal
  - The location of all certificates are passed into the exec start file for the api server or the service's configuration file, specifically:
    ```shell
    ExecStart=/usr/local/bin/kube-apiserver \\
      --advertise-address=${INTERNAL_IP} \\
      --allow-privileged=true \\
      --apiserver-count=3 \\
      --authorization-mode=Node,RBAC \\
      --bind-address=0.0.0.0 \\
      --enable-swagger-ui=true \\
      --etcd-cafile=/var/lib/kubernetes/ca.pem \\
      --etcd-certfile=/var/lib/kubernetes/apiserver-etcd-client.crt \\
      --etcd-keyfile=/var/lib/kubernetes/apiserver-etcd-client.key \\
      --etcd-servers=https://127.0.0.1:2379 \\
      --event-ttl=1h \\
      --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\
      --kubelet-client-certificate=/var/lib/kubernetes/apiserver-kubelet-client.crt  \\
      --kubelet-client-key=/var/lib/kubernetes/apiserver-kubelet-client.key
      --kubelet-https=true \\
      --runtime-configmap=api/all \\
      --service-account-key-file=/var/lib/kubernetes/service-account.pem
      --service-cluster-ip-range=10.32.0.0/24 \\
      --service-node-port-range=30000-32767 \\
      --client-ca-file=/var/lib/kubernetes/ca.pem \\
      --tls-cert-file=/var/lib/kubernetes/apiserver.crt \\
      --tls-private-key-file=/var/lib/kubernetes/apiserver.key \\
      --v=2
    ```
    - **etcd:**:
      - CA File = `--etcd-cafile`
      - ETCD Certificate = `--etchd-certfile`
      - ETCD Private Key File = `--etcd-keyfile`
    - **kubelet:**
      - CA File = `--kubelet-certificate-authority`
      - Client Certificate = `--kubelet-client-certificate`
      - Client Key = `--kubelet-client-key`
    - Client CA = `--client-ca-file`
    - API Server Cert and Private Key = `--tls-cert-file`, `--tls-private-key-file`

- **Kubelet Server:**
  - A HTTPS API server on each worker node to help manage the nodes
  - Key-Certificate pair required for each worker node in the cluster
  - Named after each node
  - Must be referenced in the kubelet config file for each node, specifically:
    - **Client CA file**
    - **TLS Certificate file** (kubelet-node01.crt for example)
    - **TLS Private Key File** (kubelet-node01.key for example)
  - Client certificates used to authenticated to the Kube API Server
    - Naming convention should be `system:node:nodename`
  - Nodes must also be added to `system:nodes` group for associated privileges

## View Certificate Details

- The generation of certificates depends on the cluster setup
  - If setup manually, all certificates would have to be generated manually in a similar manner to that of the previous sections
    - Components deployed as native services in this manner
  - If setup using a tool such as kubeadm, this is all pre-generated
    - Components deployed as pods in this manner
- For **Kubeadm clusters:**
  - Component found in `/etc/kubernetes/pki/` folder
    - Certificate file paths located within component's yaml files
    - Example: `apiserver.crt`
    - Use `openssl x509 -in /path/to/.crt file -text -noout`
  - Can check the certificate details such as name, alternate names, issuer and expiration dates
- **Note:** Additional details available in the documentation for certificates
- Use `kubectl logs <podname>` on kubeadm if any issues are found with the components
- If `kubectl` is unavailable, use Docker to get the logs of the associated container:
  - Run `docker ps - a` to identify the container ID
  - View the logs via `docker logs <container ID>`
- A sample health check spreadsheet can be found here:
https://github.com/mmumshad/kubernetes-the-hard-way/tree/master/tools