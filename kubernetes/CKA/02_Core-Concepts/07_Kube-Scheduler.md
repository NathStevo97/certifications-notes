# 2.7 - Kube-Scheduler

- Responsible for scheduling pods on nodes i.e. identifying the best node for objects
such as pods and deployments to be placed on.
- It's a common misconception that the scheduler is responsible for actually placing
the resources onto the nodes, this is actually Kubelet's responsibility.
- A scheduler is needed to ensure that containers and resources end up on the nodes
that can successfully accommodate them based on certain criteria:
  - Resource requirements for pod
  - Resource capacity/quota for nodes
- The scheduler follows the 2-step process to make its decision:
  - Filters nodes that don't fit the resource requirements for the pod/object
  - Uses a priority function to determine which of the remaining nodes is the
best fit for the object based on the node's resource capacity, scoring from
0-10.
■ For example, if a pod requiring 10 cpu units could be placed on a
node with 12 total units or 16, it's preferable to place it on the 16-unit
one as this leaves more space for additional objects to be deployed to
the pod.
- The scheduler also utilises other tools such as taints and tolerations, and node
selectors/affinity.
- To install the kube-scheduler, extract and run the binary from the release page as a
service; under the file kube-scheduler.service, where you can configure the options
as per usual.
- As with the Kube-API Server, the way you view the options on the Kube-Scheduler
depends on your cluster's setup:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-scheduler.yaml`
  - Non-kubeadm setup:
■ Options displayed in `kube-scheduler.service` file at
`/etc/systemd/system/kube-scheduler.service`
■ Alternatively, use `ps -aux | grep kube-scheduler` to view the process
and its associated options.
