# 7.2 - Authentication

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
