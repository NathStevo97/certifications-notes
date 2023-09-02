# 6.2 - Kubernetes Software Versions

- When installing a kubernetes cluster, a specific version of kubernetes is installed
alongside
- Can be viewed via `kubectl get nodes` in the version column
- Release versions follow the process major.minor.patch
- Kubernetes is regularly updated with new minor versions every couple of months
- Alpha and beta versions also available
- Alpha - Features disabled by default, likely to be buggy
- Beta - Code tested, new features enabled by default
- Stable release - Code tested, bugs fixed
- Kubernetes releases found in a tarball file in Github; contains all required
executables of the same version
- **Note:** Some components within the control plane will not have the same version
numbers and are released as separate files; ETCD cluster and CoreDNS servers
being the main examples