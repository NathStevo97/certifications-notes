# 3.17 - Resource Requirements

- Consider a 3-node setup, each has a set amount of resources available i.e.:
  - CPU
  - Memory
  - Disk Space

- The Kubernetes scheduler is responsible for allocating pods to nodes
  - To do so, it takes into account the node's current resource allocation and the resources requested by the pod.
  - If no resources are available, the scheduler will hold the pod back for release
- Kubernetes automatically assumes a pod or container within a pod will require at least:
  - `0.5` CPU Units
  - `256Mi` Memory

- If the pod or container requires more resources than allocated above, one can configure the pod definition file's spec, in particular, add the following under the `containers` list:

```yaml
resources:
  requests:
    memory: "1Gi"
    cpu: 1
```

## Resource - CPU

- Can be set from `1m` (1 micro) to as high as required / supported by the host system.
- 1 CPU = 1 AWS vCPU = 1 GCP Core = 1 Azure Core = 1 Hyperthread

## Resources - Memory

- Allocate within any of the following suffix for the givne purpose and the system's capabilities:

| Memory Metric | Shorthand Notation | Equivalency |
| ------------- | ------------------ | ----------- |
| Gigagbyte     | G                  | 1000M       |
| Megabyte      | M                  | 1000K       |
| Kilobyte      | K                  | 1000 Bytes  |
| Gigibyte      | Gi                 | 1024Mi      |
| Mebibyte      | Mi                 | 1024Ki      |
| Kilibyte      | Ki                 | 1024 Bytes  |

- Docker containers have no limit to the resources they can consume
- When only running on a node, it can only use a maximum of 1vCPU unit - if the limits need changing, update the pod definition file:

```yaml
resources:
  requests:
    memory: <value and unit>
    cpu: <value and limit>
    ....
  limits:
    memory: < value and unit>
    cpu: <number>
```

- The limits and requests can be set for each pod and container
- If CPU overload occurs, CPU usage is "throttled" on the node so it does not go beyond the limit.
- If repeated memory use is exceeded for an extended period of time, the pod is terminated with an `OOM` (Out of Memory) error.

## Default Behavior

- By default, Kubernetes doesn't set CPU or Memory limits, pods would be able to use as much of these resources as they like until it stops other pods from functioning.

- Rather than just putting blanket limits or requests in place, it's often advised to tailor the requests and limits per workload.
- Alternatively, you could put in requests without limits, ensuring that each pod is guaranteed the minimum resources required, but this doesn't prevent resource quota throttling.

### Limit Ranges

- To ensure all pods are created with particular limits by default, one can create a `LimitRange` object, both CPU and Memory constraints can be defined by a single LimitRange:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
spec:
  limits:
  - default:
      cpu: 500m
    defaultRequest:
      cpu: 500m
    max:
      cpu: "1"
    min:
      cpu: 100m
    type: Container
```

- Quotas can be set for a namespace itself by creating a `ResourceQuota` object - these are namespace-scoped:

```yaml
apiVersion: v1
kind:  ResourceQuota
metadata:
  name: my-resource-quota
spec:
  hard:
    requests.cpu: 4
    requests.memory: 4Gi
    limits.cpu: 10
    limits.memory: 10Gi
```
