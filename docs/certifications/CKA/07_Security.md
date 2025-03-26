# 7.0 - Security

## 7.1 - Kubernetes Security Primitives

- Controlling access to API Server is the top priority
- Need to define who can access the API Server through and what they can do
- Could use any of:
  - Files
  - Certificates
  - External authentication providers
  - Service Accounts
- By default, all pods within a cluster can access one another
- This can be restricted via the introduction of network policies

## 7.2 - Authentication

- Authentication Mechanisms Available in Kubernetes for the API Server:
  - Static Password File
  - Static Token File
  - Certificates
  - Identity Services e.g. `LDAP`
- Suppose you have the user details in a file, you can pass this file as an option for
authentication in the kube-apiserver.service file adding the flag:
`--basic-auth-file=user-details.csv`
  - Restart the service after this change is done
- If the cluster is setup using Kubeadm, edit the yaml file and add the same option
  - Kubernetes will automatically update the apiserver once the change is made
- To authenticate using the credentials specified in this manner run a curl command
similar to:
`curl -v -k https://master-node-ip:6443/api/v1/pods -u "username:password"`
- Could also have a token file, specify using `--token-auth-file=user-details.csv`
- **Note:** These are not recommended authentication mechanisms
  - Should consider a volume mount when providing the auth file in a kubeadm
setup
  - Setup RBAC for new users
- Could also setup RBAC using YAML files to create rolebindings for each user

## 7.3 - TLS Basics

- Certificates used to guarantee trust between two parties communicating with one
another, leading to a secure and encrypted connection
- Data involved in transmission should be encrypted via the use of encryption keys
- Encryption Methods:
  - Symmetric: Same key used for encryption and decryption
  - Asymmetric encryption: A public and private key are used for encryption and
decryption specifically
■ Private key can only be used for decryption
- SSH Assymetric Encryption: `run ssh-keygen`
  - Creates `id_rsa` and `id_rsa.pub` (public and private keys)
  - Servers can be secured by adding public key to authorized key file at
`~/.ssh/authorized_keys`
  - Access to the server is then allowed via ssh -i id_rsa username@server
  - For the same user, can copy the public key to any other servers
- To securely transfer the key to the server, use asymmetric encryption
- Can generate keys with: `openssl genrsa -out <name>.key 1024`
  - Can create public variant with: `openssl rsa -in <name>.key -pubout > <name>.pem`
- When the user first accesses the web server via HTTPS, they get the public key from
the server
  - Hacker also gets a copy of it
- The users browser encrypted the symmetric key using the public key
  - Hacker gets copy
- Server uses private key to decrypt symmetric key
  - Hacker doesn't have access to the private key, and therefore cannot encrypt
it.
- For the hacker to gain access, they would have to create a similar website and route
your requests
  - As part of this, the hacker would have to create a certificate
  - In general, certificates must be signed by a proper authority
  - Any fake certificates made by hackers must be self-signed
■ Web browsers have built-in functionalities to verify if a connection is
secure
- To ensure certificates are valid, the Certificate Authorities (CAs) must sign and
validate the certs.
  - Examples: Symanteg, Digicert
- To validate a certificate, one must first generate a certificate validation request to be
sent to the CA: `openssl req -new -key <name>.key -out <<name>.csr -subk "/C=US/ST=CA/O=MyOrg, Inc./CN=mybank.com"`
- CAs have a variety of techniques to ensure that the domain is owned by you
- How does the browser know what certificates are valid? CAs have a series of public
and private keys built in to the web browser, the public key is then used for
communication between the browser and CA to validate the certificates
- Note: The above are described for public domain websites
- For private websites, such as internal organisation websites, private CAs are
generally required and can be installed on all instances of the web browser within
the organisation
- Note:
  - Certificates with a public key are named with the extension .crt or .pem, with
the prefix of whatever it is being communicated with
  - Private keys will have the extension of either `.key` or `-key.pem`

## 7.4 - TLS In Kubernetes

- In the previous section, three types of certificates were discussed, for the purposes
of discussing them in Kubernetes, how they're referred to will change:
  - Public and Private Keys used to secure connectivity between the likes of web
browsers and servers: **Server Certificates**
  - Certificate Authority Public and Private Keys for signing and validating
certificates: **Root Certificates**
  - Servers can request a client to verify themselves: **Client Certificates**
- **Note:**
  - Certificates with a public key are named with the extension `.crt` or `.pem`, with
the prefix of whatever it is being communicated with
  - Private keys will have the extension of either `.key` or `-key.pem`
- All communication within a Kubernetes cluster must be secure, be it pods
interacting with one another, services with their associated clients, or accessing the
APIServer using the Kubectl utility
- Secure TLS communication is a requirement
- Therefore, it is required that the following are implemented:
- Server Certificates for Servers
  - Client Certificates for Clients

### Server Components

- Kube-API Server
■ Exposes an HTTPS service that other components and external users
use to manage the Kubernetes cluster
■ Requires certificates and a key pair
- apiserver.crt and apiserver.key
  - ETCD Server
■ Stores all information about the cluster
■ Requires a certificate and key pair
- Etcdserver.crt and apiserver.key
  - Kubelet server:
■ Exposes HHTPS API Endpoint that the Kube-API Server uses to interact
with the worker nodes
- Client Certificates:
  - All of the following require access to the Kube-API Server
  - Admin user
■ Requires certificate and key pair to authenticate to the API Server
■ admin.crt and admin.key
  - Scheduler
■ Client to the Kube-APIServer for object scheduling pods etc
- scheduler.crt and scheduler.key
  - Kube-Controller:
■ controller-manager.crt and controller-manager.key
  - Kube-Proxy
■ kube-proxy.crt and kube-proxy.key
- Note: The API Server is the only component that communicates with the ETCD
server, which views the API server as a client
  - The API server can use the same keys as before for serving itself as a service
OR a new pair of certificates can be generated specifically for ETCD Server
Authentication
  - The same principle applies for the API Server connecting to the Kubelet
service
- To verify the certificates, a CA is required. Kubernetes requires at least 1 CA to be
present; which has its own certificate and key (ca.crt and ca.key)

## 7.5 - TLS in Kubernetes: Certificate Creation

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

## 7.6 - View Certificate Details

- The generation of certificates depends on the cluster setup
  - If setup manually, all certificates would have to be generated manually in a
similar manner to that of the previous sections
■ Components deployed as native services in this manner
  - If setup using a tool such as kubeadm, this is all pre-generated
■ Components deployed as pods in this manner
- For Kubeadm clusters:
  - Component found in `/etc/kubernetes/manifests/` folder
■ Certificate file paths located within component's yaml files
■ Example: apiserver.crt
■ Use `openssl x509 -in /path/to/.crt` file -text -noout
  - Can check the certificate details such as name, alternate names, issuer and
expiration dates
- Note: Additional details available in the documentation for certificates
- Use `kubectl logs <podname>` on kubeadm if any issues are found with the
components
- If kubectl is unavailable, use Docker to get the logs of the associated container:
  - Run `docker ps - a` to identify the container ID
  - View the logs via `docker logs <container ID>`

## 7.7 - Certificates API

- All certificates have an expiration date, whenever the expiry happens, keys and
certificates must be re-generated
- As discussed, the signing of the certificates is handled by the CA Server
- The CA server in reality is just a pair of key and certificate files generated
- Whoever has access to these files can sign any certificate for the Kubernetes
environment, create as many users they want and set their permissions
- Based on the previous point, it goes without saying these files need to be protected
  - Place the files on a fully secure server
  - The server that securely hosts these files becomes the "CA Server"
  - Any time you want to sign a certificate, it is the CA server that must be logged
onto/communicated with
- For smaller clusters, it's common for the CA server to actually be the master node
  - The same applies for a kubeadm cluster, which creates a CA pair of files and
stores that on the master node
- As clusters grow in users, it becomes important to automate the signing of
certificate requests and renewing expired certificates; this is handled via the
Certificates API
  - When a certificate needs signing, a Certificate Signing Request is sent to
Kubernetes directly via an API call
  - Instead of an admin logging onto the node and manually signing the
certificate, they create a Kubernetes API object called
CertificateSigningRequest
  - Once the API object is created, any requests like this can be seen by
administrators across the cluster
  - From here, the request can be reviewed and approved using kubectl, the
resultant certificate can then be extracted and shared with the user
- Steps:
  - User generates key: `openssl genrsa -out <keyname>.key 2048`
  - User generates certificate signing request and sends to administrator:
`openssl req -new -key <key>.name -subk "/CN=name" -out name.csr`
  - Admin receives request and creates the API object using a manifest file,
where the spec file includes the following:
■ **Groups** - To set the permissions for the user
■ **Usages** - What is the user able to do with keys with this certificate to
be signed?
■ Request - The certificate signing request associated with the user,
which must be encoded in base64 language first i.e. `cat cert.crt | base64`
■ Admins across the cluster can view certificate requests via: `kubectl | get csr`
■ If all's right with the csr, any admin can approve the request with:
`kubectl certificate approve <name>`
■ You can view the CSR in a YAML form, like any Kubernetes object by appending `-o yaml` to the `kubectl get command`
- **Note:** The certificate will still be in base64 code, so run: `echo "CODED CERTIFICATE" | base64 --decode`
- Note: The controller manager is responsible for all operations associated with approval and management of CSR
- The controller manager's YAML file has options where you can specify the key and
certificate to be used when signing certificate requests:
  - `--cluster-signing-cert-file`
  - `--cluster-signing-key-file`

## 7.8 - KubeConfig

- Files containing information for different cluster configurations, such as:
  - -`-server`
  - `--client-key`
  - `--client-certificate`
  - `--certificate-authority`
- The existence of this file removes the need to specify the option in the CLI
- File located at `$HOME/.kube/config`
- KubeConfig Files contain 3 sections:
  - Clusters - Any cluster that the user has access to, local or cloud-based
  - Users - User accounts that have access to the clusters defined in the previous
section, each with their own privileges
  - Contexts - A merging of clusters and users, they define which user account
can access which cluster
- These config files do not involve creating new users, it's simply configuring what
existing users, given their current privileges, can access what cluster
- Removes the need to specify the user certificates and server addresses in each
kubectl command
  - `--server` spec listed under clusters
  - User keys and certificates listed in Users section
  - Context created to specify that the user "MyKubeAdmin" is the user that is
used to access the cluster "MyKubeCluster"
- Config file defined in YAML file
  - ApiVersion = v1
  - Kind = Config
  - Spec includes the three sections defined previously, all of which are arrays
  - Under clusters: specify the cluster name, the certificate authority associated
and the server address
  - Under users, specify username and associated key(s) and certificate(s)
  - Under contexts:
    - Name format: username@clustername
    - Under context specify cluster name and users
  - Repeat for all clusters and users associated
- The file is automatically read by the kubectl utility
- Use current-context field in the yaml file to set the current context
- **CLI Commands:**
  - View current config file being used: `kubectl config view`
    - Default file automatically used if not specified
    - To view non-default config files, append: `--kubeconfig=/path/to/file`
  - To update current context: `kubectl config use-context <context-name>`
  - Other commands available via `kubectl config -h`
  - Default namespaces for particular contexts can be added also
- **Note:** for certificates in the config file, use the full path to specify the location
  - Alternatively use certificate-authority-data to list certificate in base64 format

## 7.9 - API Groups

- API Server accessible at master node IP address at port 6443
  - To get the version, append `/version` to a curl request to the above IP address
  - To get a list of pods, append `/api/v1/pods`
- Kubernetes' API is split into multiple groups depending on the group's purpose such
as
  - `/api` - core functionalities e.g. pods, namespaces, secrets
  - `/version` - viewing the version of the cluster
  - `/metrics` - used for monitoring cluster health
  - `/logs` - for integration with 3rd-party logging applications
  - `/apis` - named functionalities added to kubernetes over time such as deployments, replicasets, extensions
■ Each group has a version, resources, and actions associated with
them
  - `/healthz` - used for monitoring cluster health
- Use `curl http://localhost:6443 -k` to view the api groups, then append the group and grep name to see the subgroups within
- Note: Need to provide certificates to access the api server or use `kubectl proxy` to view
- Note: `kubectl proxy` is not the same as kube proxy, the former is an http proxy service to access the api server

## 7.10 - Authorization

- When adding users, need to ensure their access levels are sufficiently configured, so
they cannot make any unwanted changes to the cluster
- This applies to any physical users, like developers, or virtual users like applications
e.g. Jenkins
- Additional measures must be taken when sharing clusters with organizations or
teams, so that they are restricted to their specific namespaces
- Authorization mechanisms available are:
  - Node-based
  - Attribute-Based
  - Rule-Based
  - WebHook-based
- Node-Based:
  - Requests to the kube-apiserver via users and the kubelet are handled via the
Node Authorizer
  - Kubelets should be part of the system:nodes group
  - Any requests coming from a user with the name system-node and is aprt of
the system nodes group is authorized and granted access to the apiserver
- ABAC - Attribute-Based
  - For users wanting to access the cluster, you should create a policy in a JSON
format to determine what privileges the user gets, such as namespace
access, resource management and access, etc
  - Repeat for each users
  - Each policy must be edited manually for changes to be made, the kube
apiserver must be restarted to make the changes take effect
- RBAC
  - Instead of associating each user with a set of permissions, can create a role
which outlines a particular set of permissions
  - Assign users to the role
  - If any changes are to be made, it is just the role configuration that needs to
be changed
- Webhook
  - Use of third-party tools to help with authorization
  - If any requests are made to say the APIserver, the third party can verify if the
request is valid or not
- Note: Additional authorization methods are available:
  - AlwaysAllow - Allows all requests without checks
  - AlwaysDeny - Denies all requests without checks
- Authorizations set by `--authorization` option in the apiserver's .service or .yaml file
- Can set modes for multiple-phase authorization, use --authorization-mode and list
the authorization methods

## 7.11 - RBAC

- To create a role, create a YAML file
- Spec replaced with rules
  - Covers apiGroups, resources and verbs
- Multiple rules added by - apiGroups for each
  - Create the role using `kubectl create -f`
- To link the user to the role, need to create a Role Binding
- Under `metadata`:
  - Specify subjects - Users to be affected by the rolebinding, their associated
apiGroup for authorization
  - RoleRef - The role to be linked to the subject
- To view roles: `kubectl get roles`
- To view rolebindings: `kubectl get rolebindings`
- To get additional details: `kubectl describe role/rolebinding <name>`
- To check access level: `kubectl auth can-i <command/activity>`
- To check if a particular user can do an activity, append `--as <username>`
- To check if an activity can be done via a user in a particular namespace, append
`--namespace <namespace>`
- Note: Can restrict access to particular resources by adding resourceNames:
`["resource1", "resource2", ...]` to the role yaml file

## 7.12 - ClusterRoles and Rolebindings

- Roles and role bindings are created for particular namespaces and control access to
resources in that particular namespace
- By default, roles and role bindings are applied to the default namespace
- In general, resources such as pods, replicasets are namespaced
- Cluster-scoped resources are resources that cannot be associated to any particular
namespace, such as:
  - Persistentvolumes
  - Nodes
- To switch view namespaced/cluster-scoped resources: `kubectl api-resources --namespaced=TRUE/FALSE`
- To authorize users to cluster-scoped resources, use cluster-roles and cluster-rolebindings
  - Could be used to configure node management across a cluster etc
- Cluster roles and role bindings are configured in the exact same manner as roles
and rolebindings; the only difference is the kind
- Note: Cluster roles and rolebindings can be applied to namespaced resources

## 7.13 - Image Security

- Docker images follow the naming convention where `image: <image name>`
  - Image name = image / repository referenced
  - i.e. library/image name
    - Library = default account where docker official images are stored
    - If referencing from a particular account - swap library with account name
  - Images typically pulled from docker registry at docker.io by default
- Private repositories can also be referenced
  - Requires login via `docker login <registry name>`
  - It can then be referenced via the full path in the private registry
  - To facilitate the authentication - create a secret of type docker-registry i.e.:

`kubectl create secret docker-registry <name> --docker-server=<registry name> --docker-username=<username> --docker-password=<password> --docker-email=<email>`

Then, in the pod spec, add:

```yaml
imagePullSecrets:
- Name: <secret name>
```

## 7.14 - SecurityContext

- When running docker containers, can specify security standards such as the ID of
the user to run the container
- The same security standards can be applied to pods and their associated containers
- Configurations applied a pod level will apply to all containers within
- Any container-level security will override pod-level security
- To add security contexts, add securityContext to either or both the POD and
Container specs; where user IDs and capabilities can be set

## 7.15 - Network Policy

### Traffic Example

- Suppose we have the following setup of servers:
  - Web
  - API
  - Database
- Network traffic will be flowing through each of these servers across particular ports, for example:
- Web user requests and receives content from the web server on port 80 for HTTP
- Web server makes a request to the API over port 5000
- API requests for information from the database over port 3306 (e.g. if MySQL)

- 2 Types of Network Traffic in this setup:
  - **Ingress:** Traffic to a resource
  - **Egress:** Traffic sent out from a resource

- For the setup above, we could control traffic by allowing ONLY the following traffic to and from each resource across particular ports:
  - Web Server:
    - Ingress: 80 (HTTP)
    - Egress: 5000 (API port)
  - API Server:
    - Ingress: 5000
    - Egress: 3306 (MySQL Database Port)
  - Database Server:
    - Ingress: 3306

- Considering this from a Kubernetes perspective:
  - Each node, pod and service within the cluster has its own IP address
  - When working with networks in Kubernetes, it's expected that the pods should be able to communicate with one another, regardless of the olution to the project
    - No additional configuration required
- By default, Kubernetes has an "All-Allow" rule, allowing communication between any pod in the cluster.
  - This isn't best practice, particularly if working with resources that store very sensitive information e.g. databases.
  - To restrict the traffic, one can implement a network policy.

---

- A network policy is a Kubernetes object allowing only certain methods of network traffic to and from resources. An example follows:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: network-policy
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod
    ports:
    - protocol: TCP
      port: 3306
```

- The policy can then be created via `kubectl create -f ....`

- Network policies are enforced and supported by the network solution implemented on the cluster.
- Solutions that support network policies include:
  - kube-router
  - calico
  - romana
  - weave-net

- Flannel doesn't support Network Policies, they can still be created, but will not be enforced.

## 7.16 - Developing Network Policies

- When developing network policies for pods, always consider communication from
the pods perspective
- PolicyTypes Available:
  - Ingress - Incoming traffic
  - Egress - Outgoing traffic
■ Both can be implemented if desired
- Each ingress rule has a from and ports field:
  - From describes the pods which the pod affected by the policy can accept
ingress communication
  - For additional specification, can use podSelector and namespaceSelector or ipBlock to specify particular IP addresses
  - Each rule start denoted by -
  - Ports - Network ports communication can be received from
- For egress rules, the only difference is "from" is replaced with "to"
