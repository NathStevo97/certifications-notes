# 3.8 - Daemonsets

- Daemonsets are similar in nature to replicasets, they provide assistance in the
deployment of multiple instances of a pod
- Daemonsets run only one instance of the pod per node
- Whenever a new node is added, the pod is automatically added to the node and vice
versa for when the node is removed
- Use cases of Daemonsets include monitoring and logging agents
  - Removes the need for manually deploying one of these pods to any new
nodes within the cluster
  - Kubernetes components such as Kube-Proxy could be deployed as a
Daemonset as one pod is required per cluster
■ Similar network solutions could also be deployed as a Daemonset
- Daemonsets can be deployed via a definition file, it's similar in structure to that of a
Replicaset, with the only difference being the Kind

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
    template:
      metadata:
        labels:
          app: monitoring-agent
      spec:
        containers:
        - name: monitoring-agent
          image: monitoring-agent
```

- To view daemonsets, use the kubectl get daemonsets command
- You can view the details of the daemonset with the kubectl describe command i.e. `kubectl describe daemonset <daemonset name>`
- Prior to Kubernetes v1.12, a Daemonset would work by manually setting the
nodename for each pod to be allocated, thus bypassing the scheduler
- Post Kubernetes v1.12, the Daemonset uses the default scheduler and Node Affinity
rules discussed previously to allocate the single pod to each node