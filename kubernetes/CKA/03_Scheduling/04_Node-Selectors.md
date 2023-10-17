# 3.4 - Node Selectors

- Consider a 3-node cluster, with 1 node having a larger resource configuration:
  - In this scenario, one would like the task/process requiring more resources to go to the larger node.
- To solve, can place limitations on pods
- This can be done via the `nodeSelector` property in the definition file:

```yaml
nodeSelector:
  size: node-label
```

- NodeSelectors require the node to be labelled: `kubectl label nodes <node name> <label key>=<key value>`

- When pod is created, it should be assigned to the labelled node so long as the resources allow it.

## Limitations of NodeSelectors

- NodeSelectors are beneficial for simple allocation tasks, but if more complex allocation is needed, Node Affinity is recommended, e.g. "go to either 1 of 2 nodes".
