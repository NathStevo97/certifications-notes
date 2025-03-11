# 9.7 - Role-Based Access Control (RBAC)

- To create a role, create a YAML file
- Spec replaced with `rules`
  - Covers apiGroups, resources and verbs
- Multiple rules added by - `apiGroups` for each
  - Create the role using `kubectl create -f`
- To link the user to the role, need to create a Role Binding
- Under `metadata`:
  - Specify `subjects` - Users to be affected by the `rolebinding`, their associated
apiGroup for authorization
  - `RoleRef` - The role to be linked to the subject
- To view roles: `kubectl get roles`
- To view rolebindings: `kubectl get rolebindings`
- To get additional details: `kubectl describe role/rolebinding <name>`
- To check access level: `kubectl auth can-i <command/activity>`
- To check if a particular user can do an activity, append `--as <username>`
- To check if an activity can be done via a user in a particular namespace, append
`--namespace <namespace>`
- **Note:** Can restrict access to particular resources by adding resourceNames:
`["resource1", "resource2", ...]` to the role yaml file
