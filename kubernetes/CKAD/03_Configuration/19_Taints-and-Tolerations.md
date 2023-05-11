# 3.19 - Taints and Tolerations

- Used to set restrictions regarding what pods can be scheduled on a node.
- Consider a cluster of 3 nodes with 4 pods preparing for launch:
  - The scheduler will place the pods across all nodes equally if no restriction applies

- Suppose now only 1 node has resources available to run a particular application:
  - A taint can be applied to the node in question; preventing any unwanted pods from being scheduled on it.
  - Tolerations then need to be applied to the pod(s) to specifically run on node 1

- Pods can only run on a node if their tolerations match the taint applied to the node.

- Taints and tolerations allow the scheduler to allocate pods to required nodes, such that all resources are used and allocated accordingly.

- **Note:** By default, no tolerations are applied to pods.

## Taints - Node

- To apply a taint: `kubectl taint nodes <nodename> key=value:<taint-effect>`
- The key-value pair defined could match labels defined for resources e.g `app=frontend`
- The taint effect determines what happens to pods that are intolerant to the taint, 1 of 3 possibilities can be specified:
  - `NoSchedule` - Pods won't be scheduled.
  - `PreferNoSchedule` - Try to avoid scheduling if possible.
  - `NoExecute` - New pods won't be scheduled, and any pre-existing pods intolerant to the taint are stopped and evicted.

## Tolerations - Pod

- To apply a toleration to a pod, one can look at the definition file
- In the spec section, add similar to the following:

```yaml
tolerations:
- key: app
  operator: "Equal"
  value: "blue"
  effect: "NoSchedule"
```

- Be sure to apply the same values used when applying the taint to the node.
- All values added need to be enclosed in " ".

## Taint - NoExecute

- Suppose Node1 is to be used for a particular application:
  - Apply a taint to node 1 with the app name and add a toleration to the pod running the app.
  - Setting the taint effect to `NoExecute` causes existing pods on the node that are intolerant to be stopped and evicted.

- Taints and tolerations are only used to restrict pod access to nodes.
- As there are no restrictions / taints applied to the other pods, there's a chance the app could still be placed on a different node(s).
- If wanting the pod to go to a particular node, one can utilise node affinity.

- **Note:** A taint is automatically applied to the master node, such that no pods can be scheduled to it.
  - View it via `kubectl describe node kubemaster | grep Taint`