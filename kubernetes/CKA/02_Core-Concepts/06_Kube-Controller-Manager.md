# 2.6 - Kube-Controller Manager

- The kubernetes component that manages each of the controllers within Kubernetes.
- Each controller has their own set of responsibilities, such as monitoring and
responding to changes in kubernetes resources or containers.
  - Continuous monitoring determined by "Watch Status"
  - Responsive actions carried out to "Remediate the situation"
- In terms of Kubernetes:
  - Controllers are processes that continuously monitor the state of various
components within the system
  - If any changes occur that negatively affect the system, the controllers work
towards bringing the system back to "normal"
- A common example of a controller us the node controller
  - Monitors the status of nodes in the cluster and takes responsive actions to
keep it running
- Any actions a controller takes are done via the kube-api server.
- The monitoring period for controllers can be configured and varies, for example the
node controller checks the status of the nodes every 5 seconds.
  - Allows frequent and accurate monitoring
  - If the controller cannot communicate with a node after 40 seconds, it's
marked as "Unreachable"
  - If after 5 minutes the node is still unreachable, the controller takes any pods
originally on the node and places them on a healthy available one.
- Another example is the replication controller
  - Responsible for monitoring the status of replicasets and ensuring that the
desired number of pods are available at all times within the set.
  - If a pod dies, it creates another.
- Many more controllers are found within Kubernetes, such as:
  - Deployments
  - CronJobs
  - Namespace
- All controllers are packaged as part of the Kube-Controller Manager; a single
process
- To install and view the Kubernetes Controller Manager. You can download and
extract the binary from the Kubernetes release page via wget etc, where you can
then run it as a service.
- When running the Kubernetes Controller Manager as a service, you can see that
there are a list of customisable options available.
  - Some options that are customizable include node monitor grace period,
monitoring period etc.
- You can also use the `--controllers` flag to configure and view what controllers you're
using.
- As with the Kube-API Server, the way you view the options on the Kube-Controller
Manager depends on your cluster's setup:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-controller-manager.yaml`
  - Non-kubeadm setup:
■ Options displayed in `kube-controller-manager.service`file at
`/etc/systemd/system/kube-apiserver.service`
■ Alternatively, use `ps -aux | grep kube-controller-manager` to view
the process and its associated options.
