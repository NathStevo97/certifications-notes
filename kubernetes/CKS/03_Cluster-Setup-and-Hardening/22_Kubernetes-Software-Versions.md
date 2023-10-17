# 3.22 - Kubernetes Software Versions

- API Versions
  - When installing a Kubernetes cluster, a particular version of Kubernetes is
installed
  - Viewable via Kubectl get nodes
- Kubernetes versions are done via `<Major>.<Minor>.<Patches>`
- This is the standard software release pattern.
- Alpha and Beta versions used to test and integrate features into main stable
releases.
- View Kubernetes GitHub repo's release page for details.
  - Packages contain all the required components of the same version.
  - For components like CoreDNS and ETCD, details on supported versions are
provided as they are separate projects.

- **Reference Links**
  - <https://github.com/kubernetes/kubernetes/releases>
  - <https://github.com/kubernetes/community/blob/master/contributors/design-proposals/release/versioning.md>
  - <https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md>
  - <https://blog.risingstack.com/the-history-of-kubernetes/>
  - <https://kubernetes.io/docs/setup/version-skew-policy>
