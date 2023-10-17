# 3.5 - Node Affinity

- Node affinity looks to ensure that pods are hosted on the desired nodes
- Can ensure high-resource consumption jobs are allocated to high-resource nodes

- Node affinity allows more complex capabilities regarding pod-node limitation.

- To specify in the spec section of a pod definition filem add in a new field:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      matchExpressions:
      - key: size
        operator: In
        values:
        - Large
```

- **Note:** For the example above, the `NotIn` operator could also be used to avoid particular nodes.
- **Note:** If just needing a pod to go to any node with a particular label, regardless of value, use the `Exists` operator -> no values are required in this case.

- Additional operators are available, with further details provided in the documentation.
- In the event that a node cannot be allocated due to a lable fault, the resulting action is dependent upon the NodeAffinityType set.

## Node Affinity Types

- Defines the scheduler's behaviour regarding Node Affinity and pod lifecycle stages

- 2 main types available:
  1. `RequireDuringSchedulingIgnoredDuringExecution`
  1. `PreferredDuringSchedulingIgnoredDuringExecution`

- Other types are to be released such as `requiredDuringSchedulingRequiredDuringExecution`

- Considering the 2 available types, can break it down into the 2 stages of a pod lifecycle:
  1. DuringScheduling -> The pod has been created for the first time and not deployed
  2. DuringExecution

- If the node isn't available according to the NodeAffinity, the resultant action is dependent upon the NodeAffinity type:

- **Required:**
  - Pod must be placed on a node that satisfies the node affinity criteria
  - If no node satisfies the criteria, the pod won't be scheduled
  - Generally used when the node placement is crucial

- **Preferred:**
  - Used if the pod placement is less important than the need for running the task
  - If a matching node not found, the scheduler ignores the NodeAffinity
  - Pod placed on any available node

- Suppose a pod has been running and a change is made to the Node Affinity:
  - The response is determined by the prefix of `DuringExecution`:
    - **Ignored:**
      - Pods continue to run
      - Any changes in Node Affinity will have no effect once scheduled.
    - **Required:**
      - When applied, if any current pods that don't meet the NodeAffinity requirements are evicted.
