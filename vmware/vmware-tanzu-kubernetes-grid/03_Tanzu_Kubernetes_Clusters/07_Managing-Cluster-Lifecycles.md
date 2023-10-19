# 3.7 - Managing Cluster Lifecycles

Tags: Done

## Learner Objectives

- Describe the VMs that make up a Tanzu Kubernetes cluster
- Describe the pods that run on a Tanzu Kubernetes Cluster
- Describe the Tanzu Kubernetes Grid core add-ons that are installed on a cluster

## Tanzu Kubernetes Cluster VMs

- Depending on the plan used, the following VMs will be created:
  - Control plan VMs: `<cluster name>-control-pane-......`
  - Worker node VMs: `<cluster name>-md-0-........`
- There will always be one or more of each.

## Upstream Kubernetes Components

- A number of standard Kubernetes components will be included upon deployment.

![Untitled](img/kubernetes-components.png)

- Architecturally:

![Untitled](img/kubernetes-component-architecture.png)

## Kubernetes API High-Availability

- The component `kube-vip` provides HA load-balancing for the Kubernetes control-plane
- By default, if included, it runs on every control plane.
- In classic HA fashion, one of the nodes will be elected the "leader" and advertises the virtual IP address using Address Resolution protocol
- If the node fails or becomes unhealthy, a leader election happens - a new leader will be elected from the available controlplane nodes and the winner will advertise the virtual IP address via ARP.

## Authentication Core Addons

- By default, TKG will implement Pinniped for cluster authentication, it comes with the following components:

![Untitled](img/authentication-addons.png)

## Networking Core Addons

- Tanzu Kubernetes Grid supports Antrea (default) or Calico as the container network interface (CNI) for in-cluster networking.
- Each come with their own components:

![Untitled](img/networking-addons.png)

## vSphere Core Addons

- For each IaaS provider - additional components will also be deployed. For vSphere, the components are outlined as follows.

![Untitled](img/vsphere-core-addons.png)

## Metrics Core Addons

- Tanzu Kubernetes Grid deploys a metrics server to management and workload clusters by default:
- metrics-server: Collects resource metrics from kubelets and exposes them in the Kubernetes API for use by Horizontal and Vertical Pod autoscalers
