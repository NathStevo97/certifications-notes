# 2.8 - Kubelet

- Kubelet registers nodes and other objects within Kubernetes to their required
places on a cluster.
- When it receives instructions from the kube-scheduler via the kube-api server to
load a container, pod etc on the node, it requests the container runtime (usually
Docker), to pull the required image.
- Once the request is made, it continues to periodically monitor the state of the pod
and the containers within, reporting its findings to the kube-apiserver.
- When installing the kubelet, it must be noted that if setting up a cluster via
kubeadm, the kubelt isn't automatically deployed.
  - This is a KEY difference.
  - You must always manually install the kubelet on your worker nodes.
- To install, download the binary from the release page, from which you can extract
and run it as a service under `kubelet.service`
- The associated options can be viewed by either:
  - `/etc/systemd/system/kubelet.service`
■ Options can be configured within the file
  - `ps -aux | grep kubelet`
