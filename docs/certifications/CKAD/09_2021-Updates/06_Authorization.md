# 9.6 - Authorization

- When adding users, need to ensure their access levels are sufficiently configured, so they cannot make any unwanted changes to the cluster
- This applies to any physical users, like developers, or virtual users like applications e.g. Jenkins
- Additional measures must be taken when sharing clusters with organizations or teams, so that they are restricted to their specific namespaces
- **Authorization mechanisms available are:**
  - Node-based
  - Attribute-Based
  - Rule-Based
  - WebHook-based
- **Node-Based:**
  - Requests to the kube-apiserver via users and the kubelet are handled via the Node Authorizer
  - Kubelets should be part of the system:nodes group
  - Any requests coming from a user with the name system-node and is aprt of
the system nodes group is authorized and granted access to the apiserver
- **ABAC - Attribute-Based**
  - For users wanting to access the cluster, you should create a policy in a JSON
format to determine what privileges the user gets, such as namespace
access, resource management and access, etc
  - Repeat for each users
  - Each policy must be edited manually for changes to be made, the kube
apiserver must be restarted to make the changes take effect
- **RBAC**
  - Instead of associating each user with a set of permissions, can create a role
which outlines a particular set of permissions
  - Assign users to the role
  - If any changes are to be made, it is just the role configuration that needs to
be changed
- **Webhook**
  - Use of third-party tools to help with authorization
  - If any requests are made to say the APIserver, the third party can verify if the request is valid or not
- **Note:** Additional authorization methods are available:
  - `AlwaysAllow` - Allows all requests without checks
  - `AlwaysDeny` - Denies all requests without checks
- Authorizations set by `--authorization` option in the apiserver's .service or .yaml file
- Can set modes for multiple-phase authorization, use `--authorization-mode` and list
the authorization methods
