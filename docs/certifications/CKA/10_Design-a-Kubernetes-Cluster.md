# 10.0 - Design a Kubernetes Cluster

- [10.0 - Design a Kubernetes Cluster](#100---design-a-kubernetes-cluster)
  - [Design a Kubernetes Cluster](#design-a-kubernetes-cluster)
  - [Choosing Kubernetes Infrastructure](#choosing-kubernetes-infrastructure)
  - [Configure High-Availability](#configure-high-availability)
  - [ETCD In High-Availability](#etcd-in-high-availability)

## Design a Kubernetes Cluster

- Considerations must be made when designing a cluster, such as:
  - Purpose
  - Workload to be hosted
    - Cloud or On-Prem
- For production clusters, should consider a high availability setup
  - Kubeadm or GCP or other supported platforms
  - Multiple nodes and master nodes
  - For cloud hosted kubernetes clusters, resource requirements are predefined
  - For on-prem, could use the figures from previous for reference
  - Kops - A popular tool for deploying Kubernetes on AWS
- Minimum of 4 nodes required (1 master, 3 workers)
- Nodes must use the Linux x64 OS
- Could separate ETCD cluster to own node, separate from the master

## Choosing Kubernetes Infrastructure

- For Kubernetes on a laptop, multiple options available:
  - For Linux, could install binaries - Tedious, but worth it
  - For Windows, no native support available, Hyper-V, Virtualbox etc required to
run Linux in a virtualised manner
- Minikube creates a single-node cluster easily, good for beginners practicing
- Kubeadm - Can be used to quickly deploy a multi-node cluster, though the host
must be configured beforehand
- Turnkey solutions - Solutions where VMs required are manually configured and
maintained
  - OpenShift as an example - Built on top of Kubernetes and easily integratable
with CI/CD
90
  - CloudFoundry - Helps deploy and manage highly available kubernetes
clusters
  - VMWare cloud PKS
  - Vagrant - Providers scripts to deploy kubernetes clusters on different cloud
providers
- Hosted Solutions (Managed) - Kubernetes-as-a-service solution
  - VMs maintained and provisioned by cloud provider
  - Examples:
    - Google Container Engine (GKE)
    - Openshift Online
    - Azure Kubernetes Service
    - Amazon Elastic Container Service for Kubernetes
- For the purposes of education, Virtualbox is probably the best place to start

## Configure High-Availability

- As long as the worker nodes are available and nothing is going wrong, the
applications on worker nodes will run even if the master node is unavailable
- Multiple master nodes are recommended for high-availability clusters; even if one
master node goes down, it's all good.
- For multiple master nodes, it's better to have a load balancer to split traffic between
the two api servers, nginx, ha-proxy are all good examples
  - Other components like scheduler and kube-controller can't run at the same
time across multiple master nodes
  - Can leverage a leader-elect approach for an active-standby approach
    - If one receives the request first, it becomes the leader-elect
    - Configure using the following options:
      `- --leader-elect true`
      - `--leader-elect-lease-duration <x>s` (how long does the non-leader wait until attempting to become the leader again)
      - `--leader-elect-renew-deadline <x>s` (interval between acting master attempting to renew a leadership slot before it stops leading (must be equal or less than lease duration)
      - `--leader-elect-retry-period <x>s` (The duration the clients should wait between attempting acquisition and renewal of a leadership)
- If ETCD is part of the master nodes: Stacked topology
  - Easy setup and management
  - Fewer servers involved
  - Poses a risk when failures occur
- External ETCD Topology - ETCD setup on a separate node
  - Less risky
  - Harder to setup
- Where the etcd is setup can be determined by the --etcd-servers option on the
apiservers configuration

## ETCD In High-Availability

- ETCD Previously deployed as one server, but can run multiple instances, each
containing the same data as a fault-tolerant measure
- To allow this, ETCD needs to ensure that all instances are consistent in terms of
what data they store, such that you can write to and read data from any of the
instances
- In the event multiple write requests come in to an ETCD, the leader-elect processes
the write request, which then transfers a copy to the other nodes
- Leaders decided using RAFT algorithm, using random timers for initiating requests
  - The first to finish the request becomes the leader
  - Sends out continuous notifications from then on saying "i'm continuing as leader"
  - If no notifications received e.g. the leader goes down, reelection occurs
- A write will only be considered if the transfer is completed to the majority of the
Nodes or the Quorum
- **Quorum = N/2 + 1**; where N = Node number (for .5 numbers, round down)
- **Quorum = Minimum number of nodes in an N-node cluster that need to be running for a cluster to operate as expected.**
Fault Tolerance = Instances Number - Quorum
- Odd number of master nodes recommended
- To install etcd, download the binaries from the Github repo and configure the
certificates (See previous sections) and configure in `etcd.service`
- Etcdctl can be used to backup the data
- ETCDCTL_API default version = 2, 3 COMMONLY USED
- For ETCD, the following number of nodes are recommended: 3, 5 or 7
