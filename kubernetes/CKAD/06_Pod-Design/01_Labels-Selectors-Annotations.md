# 6.1 - Lables, Selectors and Annotations

- Labels and selectors allow standardised categorisation of resources or objects
  - Objects can then be filtered by the categories selected

- **Labels:** Properties attached to each item
- **Seclectors:** Filter criteria for items based on labels
  - E.g. Kind: Pod
- Over time one could end up with thousands of objects in a cluster, includign Pods, nodes, etc.
  - Need to filter and categorise them.
- Could group objects via:
  - Type
  - Associated application
  - Functionality

- For each object, a label(s) can be associated.
- Appropriate selectors can be applied to filter objects

- To apply labels, add them under the object's `metadata` list as another list, in a similar manner to the following:

```yaml
....
metadata:
  name: simple-webapp
  labels:
    app: app1
    function: frontend
....
```

- To select a pod of appropriate label: `kubectl get pods --selector <key>=<value>`

- Kubernetes also uses labels and selectors internally to connect different objects.
  - Example: for a replicaset, one needs to configure the replicaset to match labels for a particular key-value pair
    - If matched correctly, the replicaset is created and manages the desired pods.

## Annotations

- Used to record details for informatory purposes, such as:
  - Build version
  - IDs for integrations
- Added under metadata in a similar manner to that of labels.

```yaml
metadata:
  name: annotations-demo
  annotations:
    imageregistry: "https://hub.docker.com/"
```
