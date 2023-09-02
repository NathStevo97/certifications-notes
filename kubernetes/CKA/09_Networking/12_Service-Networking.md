# 9.12 - Service Networking

- Don't want to make each pod communicate with one another, can use services to
leverage this
- Each service runs at a particular IP address and is accessible by any pod from any
node, they aren't bound to a particular node
- ClusterIP = Service exposed to particular cluster only
- NodePort = Runs on a particular port on all nodes, with its own IP
- How are these services allocated IP addresses, made available to users, etc
- Each kubelet server watches for cluster changes via the api-server, each time a pod
is to be created, it creates the pod and invokes the CNI plugin to configure the
networking for it
- Kube-proxy watches for any changes, any time a new service is created, it's invoked,
however these are virtual objects.
- Services are assigned an IP from a predefined range, associated forwarding rules
are assigned to it via the `kube-proxy`
- The kube-proxy creates the forwarding rules via:
  - Listening on a port for each service and proxies connections to pods
(userspace)
  - Creating ipvs rules
  - Use IP tables (default setting)
- Proxy mode configured via: `kube-proxy --proxy-mode <proxy mode>`
- When a service is created, kubernetes will assign an IP address to it, the range is set
by the `kube-api server option --service-cluster-ip-range ipNet`
  - By default, set to `10.0.0.0/24`
- Network ranges for services, pods etc. should never overlap as this causes conflicts
- `iptables -L -t net | grep <service>`
  - Displays rules created by kube-proxy for service