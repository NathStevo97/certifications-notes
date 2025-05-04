# 4.0 - Multi-Container Pods

## 4.1 - Overview

- Multiple patterns are available, such as:
  - **Ambassador**
  - **Adapter**
  - **Sidecar**

- In general, it's advised to decouple a monolithic (single-tiered) application into a series of smaller components -> microservices

- Allows ability to independently develop and deploy sets of small reusable code
  - Allows easier scalability and independent modification.

- In some cases, may need services to interact with one another, whilst still being identifiable as separate services
  - Example: web server and logging agent
  - 1 agent service would be required per web server, not merging them together.

- Only the 2 functionalities (or more) need to work together that can be scaled as required:
  - Multi-container pods required

- Multi-container pods contain multiple containers running different services, sharing aspects such as:
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

### Design Patterns

- 3 Design patterns available:
  1. Sidecar
  2. Adapter
  3. Ambassador

![Multi-Container Pod Designs](./img/multi-container-pod-design.png)

#### Sidecar

- The most common design pattern
- Uses a "helper" container to assist or improve the functionality of a primary container
- Example: Log agent with a web server

#### Adapter

- Used to assist in standardizing communications between resources
  - Processes that transmit data e.g. logs will be formatted in the same manner
  - All data stored in centralized location

#### Ambassador

- Responsible for handling proxy for other parts of the system or services
- Used when wanting microservices to interact with one another
- Services to be identified by name only via service discovery such as DNS or at an application level.

---

- Whilst the design patterns differ, their implementation is the same, adding containers to the pod definition file spec where required,

### InitContainers

- In multi-container pods, each container is expected to run a process that stays alive for the Pod's lifecycle.
- Sometimes, you may wish to run a process that runs to completion in a pod's container, such as carry out initial configuration or pull some additional code in a one-time task before the main application starts.
- This is achieved through the use of `initContainers`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ;']
```

- When the pod's first created, the process in the `initContainer` must run to completion before the main container starts.
- Multiple `InitContainers` can be configured, however they will run in the sequence defined in their YAML manifest.
