# 7.5 - TLS in Kubernetes: Certificate Creation

- Tools available for certificate creation include:
  - EASYRCA
  - OPENSSL - The more common one
  - CFSSL
- Steps - Server Certificates: CA Example
  - Generate the keys: `openssl genrsa -out ca.key 2048`
■ The number "2048" in the above command indicates the size of the
private key. You can choose one of five sizes: 512, 758, 1024, 1536 or
2048 (these numbers represent bits). The larger sizes offer greater
security, but this is offset by a penalty in CPU performance. We
recommend the best practice size of 1024.
  - Generate certificate signing request: `openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr`
  - Sign certificates: `openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt`
- Client Certificate Generation Steps: Admin User Example
  - Generate the keys: `openssl genrsa -out admin.key 2048`
  - Generate certificate signing request: `openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr`
  - Sign the certificate: `openssl x509 -req -in admin.csr -CAkey ca.key -out admin.crt`
■ The CA key pair is used for signing the new certificate, thus proving its validity
- When the admin user attempts to authenticate to the cluster, it is the certificate
admin.crt that will be used for this
- For non-admin users, need to add group details to the certificate signing request to
signal this.
  - Group called `SYSTEM:MASTERS` has administrative privileges, to specify this
for an admin user, the signing request should be like: `openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr`
- The same procedure would be followed for client certificates for the Scheduler,
Controller-Manager and Kubelet
- The certificates generated could be applied in different scenarios:
  - Could use the certificate instead of usernames and password in a REST API
call to the api server (via a curl request).
■ To do so, specify the key and the certs involved as options following
the request e.g. `--key admin.key` `--cert admin.crt` and `--cacert ca.crt`
  - Alternatively, all the parameters could be moved to the kube config yaml file,
which acts as a centralized location to reference the certificates
- **Note:** For each of the Kubernetes components to verify one another, they need a
copy of the CA's root certificate
- **Server Certificate Example: ETCD Server**
  - As ETCD server can be deployed as a cluster across multiple servers, you
must secure communication between the cluster members, or peers as
they're commonly known as.
  - Once generated, specify the certificates when starting the server
  - In the etcd yaml file, there are options to specify the peer certificates
- **Server Certificate Example: API Server:**
  - Same procedure involved, but due to the nature of the API Server, with
essentially every operation running via it, and it being referred to by multiple
names, requires a lot more information included; requiring an openssl config
file
■ Using the config file, specify DNS and IP aliases for the component
■ When generating the signing request, you can reference the config file
by appending: `--config <config name>.cnf` to the signing request
command
  - The location of all certificates are passed into the exec start file for the api
server or the service's configuration file, specifically:
■ Etcd:
- CA File
- ETCD Certificate
- ETCD Private Key File
■ Kubelet
- CA File
- Client Certificate
- Client Key
■ Client CA
■ API Server Cert and Private Key
- Kubelet Server:
  - Key-Certificate pair required for each worker node
  - Named after each node
  - Must be referenced in the kubelet config file for each node, specifically:
■ Client CA file
■ TLS Certificate file (`kubelet-node01.crt` for example)
■ TLS Private Key File (`kubelet-node01.key` for example)
  - Client certificates used to authenticated to the Kube API Server
■ Naming convention should be `system:node:nodename`
■ Nodes must also be added to `system:nodes` group for associated
privileges
