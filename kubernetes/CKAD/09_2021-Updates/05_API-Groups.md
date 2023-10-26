# 9.5 - API Groups

- API Server accessible at master node IP address at port 6443
  - To get the version, append `/version` to a curl request to the above IP address
  - To get a list of pods, append `/api/v1/pods`
- Kubernetes' A:PI is split into multiple groups depending on the group's purpose such as
  - `/api` - core functionalities e.g. pods, namespaces, secrets
  - `/version` - viewing the version of the cluster
  - `/metrics` - used for monitoring cluster health
  - `/logs` - for integration with 3rd-party logging applications
  - `/apis` - named functionalities added to kubernetes over time such as deployments, replicasets, extensions
    - Each group has a version, resources, and actions associated with
them
  - `/healthz` - used for monitoring cluster health
- Use `curl http://localhost:6443 -k` to view the api groups, then append the group and grep name to see the subgroups within
- Note: Need to provide certificates to access the api server or use `kubectl proxy` to view
- Note: `kubectl proxy` is not the same as kube proxy, the former is an http proxy service to access the api server
