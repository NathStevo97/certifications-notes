# 7.7 - Certificates API

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
