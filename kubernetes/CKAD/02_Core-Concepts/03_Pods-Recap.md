# 2.2 - Recap: Pods

- Kubernetes doesn't deploy containers directly to nodes, they're encapsulated into Pods; a Kubernetes object.
- **Pod:** A single instance of an application
  - A pod is the smallest possible object in Kubernetes

- Suppose a containersied app is running on a single pod in a single node. If the user demand increases, how is the load balanced?
- One cannot have multiple containers to a pod
- Instead, a new pod will be required with a new instance of the application
- If the user demand increases further, but no pods are available on the node; a new node has to be created.

- In general, pods and containers have a 1-to-1 relationship.

## Multi-Container Pods

- A single pod can contain more than 1 container, however it cannot be running the same application.
- In some cases, one may have a "helper" container running alongside the primary application
  - The helper container usually runs support processes such as:
    - Process user-entered data
    - Carry out initial configuration
    - Process uploaded files
  - When new pod is created, an additional helper-container will automatically be created alongside it.
  - App and helper container communicate and share resources across a shared network
  - The two containers have a 1-to-1 relationship.

## Example Kubectl Commands

- `kubectl run <container name>`
  - Runs docker container by creating a pod
  - To specify image, append `--image <image name>:<image tag>`
  - Image will then be pulled from DockerHub

- `kubectl get pods`
  - Return a list detailing the pods in the default namespace
  - Append `--namespace <namespace>` to specify a namespace.
