# 2.18 - LoadBalancer Services

- Kubernetes service type that helps balance traffic routing to underlying services and nodes within the cluster.
- Only supported on separate cloud platforms such as GCP, Azure etc
- Unsupported in environments such as Virtualbox, if still used, it basically has the same effect as a service of type NodePort.
