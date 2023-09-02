# 3.7 - Cluster Networking

- Each node within a cluster must have at least 1 interface connected to a network
- Each node's interface must have an IP address configured
- Hosts must each have a unique hostname and unique MAC address
  - Particularly important if cloning VMs
- Ports need to be opened:
- APIServer (Master Node) - Port 6443
- Kubelet (Master and Worker) - Port 10250
- Kube-Scheduler (Master) - Port 10251
- Kube-Controller-Manager - Port 10252
- ETCD - Port 2379
- Note: 2380 In addition for the case where there are multiple master nodes (allows
ETCD Clients to communicate with each other

## Note on CNI and the CKA Exam

- In the upcoming labs, we will work with Network Addons. - This includes installing a network plugin in the cluster.
- While we have used weave-net as an example, please bear in mind that you can use any of the plugins which are described here:

- https://kubernetes.io/docs/concepts/cluster-administration/addons/
-https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model

- In the CKA exam, for a question that requires you to deploy a network addon, unless specifically directed, you may use any of the solutions described in the link above.
- However, the documentation currently does not contain a direct reference to the exact command to be used to deploy a third party network addon.
- The links above redirect to third party/ vendor sites or GitHub repositories which cannot be
used in the exam.
  - This has been intentionally done to keep the content in the Kubernetes documentation vendor-neutral.
- At this moment in time, there is still one place within the documentation where you can find the exact command to deploy weave network addon:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#steps-for-the-first-control-plane-node