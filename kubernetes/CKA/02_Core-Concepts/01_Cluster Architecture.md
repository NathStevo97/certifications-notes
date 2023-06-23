# Cluster Architecture

Kubernetes exists to allow the hosting of containerized applications in an automated fashion, allowing communication between the different services associated, and facilitating the creation of however many instances you like.

**Master Node** - The node that manages, plans, schedules workloads and monitors worker nodes.

**Worker Nodes** - Nodes that host the containerised applications.

Master node is comprised of multiple tools/clusters, making up the control plane:
-	**ETCD Cluster** - Stores information about worker nodes, such as containers running within.
-	**Schedulers** - Identifies the appropriate nodes that a container should be allocated to depending on metrics such as resource requests, node affinity and selectors etc.
-	**Controllers** - Tools responsible for monitoring and responding to node changes, such as optimizing the number of containers running, responding to faulty nodes etc.
-	**Kube-API Server** - Orchestrates all operations within the cluster, exposes the Kubernetes API, which users use to perform management operations.
To run containers on the master and worker nodes, a standardized runtime environment is required, such as *Docker*.

On the worker nodes, tools included are:
-	**Kubelet** - An engine on each node that carries out operations based on requests from the master node, occasionally sending statistic reports to the kube-apiserver as part of the monitoring
-	**Kube-proxy** - Service that ensures ingress/egress rules are in place to allow inter-pod and node-node communications
