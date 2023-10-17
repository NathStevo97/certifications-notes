# 5.8 - Multi-Container Pods

- Multiple patterns are availablem such as:
  - Ambassador
  - Adapter
  - Sidecar

- In general, it's advised to decouple a monolithic (single-tiered) application into a series of smaller components -> microservices

- Allows ability to independently develop and deploy sets of small reusable code
  - Allows easier scalability and independent modification.

- In some cases, may need services to interact with one another, whilst still being identifiable as separate services
  - Example: web server and logging agent
  - 1 agent service would be required per web server, not merging them together.

- Only the 2 functionalities (or more) need to work together that can be scaled as required:
  - Multi-container pods required

- Multi-container pods contain multiple containers running different services, sharing aspects such asL
  - Network: Can refer to each other via localhost
  - Storage: No need for additional volume setup / integration
  - Lifecycle: Resources are created and destroyed together

- To create a multi-container pod, add the additional container details to the pod's spec in a similar manner to the following:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp
  labels:
    name: simple-webapp
spec:
  containers:
  - name: simple-webapp
    image: simple-webapp
    ports:
    - containerPort: 8080

  - name: log-agent
    image: log-agent
```
