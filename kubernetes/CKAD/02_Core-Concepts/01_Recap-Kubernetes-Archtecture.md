# 2.1 - Recap: Kubernetes Architecture

## Node

- A physical or virtual machine where Kubernetes is installed
- Also known as "worker machines" or "minions"
- Containers are deployed to these nodes via the Kubernetes CLI.
- To avoid applications failing to run on a node, it's advised to have multiple nodes together or multiple replicase of an app.
  - This can support high-availability and fault-tolerance.

## Cluster

- A set of nodes grouped together
- In the event of one node or app failing, users can be redirected to another node; maintaining accessibility.
- Clusters therefore allow load balancing to be supported in Kubernetes.

## Master Node

- Watches over the worker nodes and orchestrates containers within the cluster.
- Other responsibilities include:
  - Cluster management
  - Storing information around cluster members, etc.
  - Monitoring node status
  - Managing per-node workloads.

## Cluster Components

### API Server

- Acts as the frontend for Kubernetes
- User Management devices and CLI tools all go through the API server when interacting with the cluster.

### etcd Server

- Acts as a key store service
- Stores all data used to manage the cluster
- Responsible for implementing logs within the cluster -> Avoids master-master conflicts

### Scheduler

- Distributes workloads or containers across nodes
- Looks for newly-created containers and assigns them to nodes accordingly

### Controller

- The primary orchestrators
- Responsible for noticing and responding to node/container failure, etc.
- Makes decisions to bring up new containers to replace those that have vailed (or another appropriate action

### Container Runtime

- The underlying software used to run containers.

### kubectl

- The agent running on each node.
- Responsible for ensuring containers run on nodes as expected.

## Master vs Worker Node

- Worker nodes host containers and other associated resources.
  - Requires container runtime to be installed (typically Docker)
- Master Node has Kube-API server running
- Worker nodes need the Kubelet agent to interact with the API server:
  - Provides info regarding worker node status
  - Allows ability to carry out interactions / tasks requested by the master node
- ETCD key-value store found only on the master node for security purposes
- Controller and scheduler also found on master node only - the master node handles all orchestration and workload allocation tasks.

| Master Node          | Worker Node                     |
| -------------------- | ------------------------------- |
| kube-API server      | kubelet                         |
| etcd key-value store | container runtime (e.g. Docker) |
| Controllers          |                                 |
| Scheduler            |                                 |

## Kubectl

- AKA kube-control
- Tool used to deploy and manage resources on a kubernetes cluster

- Common command examples:

```shell

# Deploy application onto cluster

kubectl run hello-minikube

# View cluster-related information

kubectl cluster-info

# Get / display information about the nodes in a cluster

kubectl get nodes

```