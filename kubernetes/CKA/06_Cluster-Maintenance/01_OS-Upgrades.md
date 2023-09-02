# 6.1 - OS Upgrades

- Suppose you have a cluster with a few nodes and pods serving applications; what
happens if one of these nodes goes down?
  - Associated pods are rendered inaccessible
  - Depending on the deployment method of these PODs, users may be
impacted
- If multiple replicas of the pod are spread across the cluster, users are uninterrupted
as it's still accessible
  - Any pods running ONLY on that node however will experience downtime
- Kubernetes will automatically try and restart the node
  - If it comes back on immediately, kubectl restarts and the pods restart
  - If after 5 mins and it's not back online, Kubernetes considers the pods as
dead and terminates them from the node
    - If part of a replicaset, the pods will be recreated on other nodes
- The time it takes for a pod to come back online is the pod eviction timeout
  - Can be set on the controller manager via: `kube-controller-manager --pod-eviction-timeout=xmys`
    - X,y = integer values
- If the node comes back online after the timeout it restarts as a blank node, any pods
that were on it and not part of a replicaset will remain "gone"
- Therefore, if maintenance is required on a node that is likely to come back within 5
minutes, and workloads on it are also available on other nodes, it's fine for it to be
temporarily taken down for upgrades
  - There is no guarantee that it'll reboot within the 5 minutes
- Nodes can be "drained", a process where they are gracefully terminated and
deployed on other nodes
  - Done so via: `kubectl drain <node name>`
  - Node cordoned and made unschedulable
- To uncordon node: `kubectl uncordon <nodename>`
- To mark the node as unschedulable, run: `kubectl cordon <nodename>`
  - Doesn't terminate any preexisting pods, just stops any more from being
scheduled
- Note: May need the flag `--ignore-daemonsets` and or `--force`
