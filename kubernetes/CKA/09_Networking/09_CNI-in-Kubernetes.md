# 3.9 - CNI in Kubernetes

- CNI Defines the best practices and standards that should be followed when
networking containers and the container runtime
- Responsibilities include:
  - Creating namespaces
  - Identifying the network a container should attach to
  - Invoke the associated network plugin (bridge) when a container is added and
deleted
  - Maintain the network configuration in a JSON format
- CNI Must be invoked by the Kubernetes component responsible for container
creation, therefore its configuration is determined by the kubelet server
- Configuration parameters for CNI in Kubelet (kubelet.service):
  - `--network-plugin=cni`
  - `--cni-bin-dir=/opt/cni/bin/`
  - `--cni-conf-dir=/etc/cni/net.d/`
- Can see these options by viewing the kubelet process
- CNI bin contains associated network plugins e.g. bridge, flannel
- Conf dir contains config files to determine the most suitable one
  - If multiple files, considerations made in alphabetical order
- IPAM section in conf considers subnets, IPs and routes etc