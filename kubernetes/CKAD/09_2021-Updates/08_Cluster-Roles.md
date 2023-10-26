# 9.8 - Cluster Roles

- Roles and role bindings are created for particular namespaces and control access to
resources in that particular namespace
- By default, roles and role bindings are applied to the default namespace
- In general, resources such as pods, replicasets are namespaced
- Cluster-scoped resources are resources that cannot be associated to any particular
namespace, such as:
  - `Persistentvolumes`
  - `Nodes`
- To switch view namespaced/cluster-scoped resources: `kubectl api-resources --namespaced=TRUE/FALSE`
- To authorize users to cluster-scoped resources, use cluster-roles and cluster-rolebindings
  - Could be used to configure node management across a cluster etc
- Cluster roles and role bindings are configured in the exact same manner as roles
and rolebindings; the only difference is the kind
- **Note:** Cluster roles and rolebindings can be applied to namespaced resources if desired, the user will then have access to the resources across all namespaces.
