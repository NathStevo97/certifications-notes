# 2.9 - Kube-Proxy

- In a cluster, every pod can interact with one another as long as a Pod Networking
solution is deployed to the cluster
  - Pod Network - An internal virtual network across all nodes within the cluster,
allowing any pod within the cluster to communicate with one another
- There are multiple solutions for deploying a pod network.
  - In one scenario, suppose you have a web application and a database running
on two separate nodes.
  - The two instances can communicate with each other via the IP of the
respective pods.
- In the example above, the problem arises when the IP of the pods aren't static, to
work around this, you can expose the pods across the cluster via a service.
- The service will have its own static IP address, so whenever a pod is to be accessed
or communicated with, communications are routed through the service's IP address
to the pod it's exposing.
- Note: The service cannot join the pod network as it's not an actual component, more
of an abstraction or virtual component.
  - It's not got any interfaces or an actively listening process.
- Despite the note, the service needs to be accessible across the cluster from any
node. This is achieved via the Kube-Proxy.
- Kube-Proxy: A process that runs on each node in the kubernetes cluster.
- The process looks for new services continuously, creating the appropriate rules on
each node to forward traffic directed to the service to the associated pods.
- To allow the rule creation, the Kube-Proxy uses IPTables rules.
  - Kube-Proxy creates an IP Tables rule on each node within the cluster to
forward traffic heading to the specific service to the designated pod; almost
like a key-value-pair.
- To install, download the binary from the release page, from which you can extract
and run it as a service under kube-proxy.service
- The kubeadm tool deploys kube-proxy as a PODs on each node
  - Kube-Proxy deployed as a Daemon Set, a single POD is always deployed on
each node in the cluster.
