# 9.14 - CoreDNS in Kubernetes

- How does Kubernetes implement DNS?
- Could add entries into /etc/hosts file -> not suitable for large scale
- Move to central dns server and specify the nameserver located at `/etc/resolv.conf`
- This works for services, but for pods it works differently
- Pod hostnames are the pod IP addresses rewritten with - instead of .
- Recommended DNS server = CoreDNS
- DNS Server deployed within the cluster as a pod in the kube-system namespace
- Deployed as a replicaset
- Runs the coredns executable
- Requires a config file named Corefile at `/etc/coredns/`
  - Details numerous plugins for handling errors, monitoring metrics, etc
- Cluster.local defined by kubernetes plugin
  - Options here determine whether pods have records
  - Set pods insecure -> pods secure
- Coredns config deployed as configmap -> edit this to make changes
- Kube-DNS deployed as a service by default, IP address configured as the
nameserver of the pod
- IP address to look at for DNS server configured via Kubelet.