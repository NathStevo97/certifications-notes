# 7.1 - Services

- Kubernetes services allows inter-component communication both within and outside Kubernetes.
- Additionally, services allow connections of applications with users or other applications.

## Example

- Suppose an application has a group of pods running various aspects of the app
  - One for serving frontend users
  - Another for backend etc
  - Another for connecting to an external data source

- All these groups of pods are connected by use of services
- Additionally, services allow frontend accessibility to users
  - Allows front-to-back pod communication and external data source communication

- One of the key services used in Kubernetes is the facilitation of external communication:
  - Suppose a pod has been deployed and is running a web app:
  - The Kubernetes node's IP address is in the same network as the local machine
  - The pod's network is separate
  - To access the container's contents, could either use a `curl` request to the IP or access via local browser
  - In practice, wouldn't want to have to ssh into the node to access the container's content, you'd want to access it as an "external" user.
  - Kubernetes service(s) cna be introduced to map the request from a local machine -> node -> pod
  - Kubernetes services are treated as objects in Kubernetes like Pods, ReplicaSets, etc.
  - To facilitate external communications, one can use NodePort:
    - Listens to a port on the node
    - Forwards requests to the required pods

- Primary service types include:
  - **NodePort:** Makes an internal pod accessible via a port on a node
  - **ClusterIP:**
    - Creates a virtual IP inside the cluster
    - Enables communication between services e.g. frontend <--> backend
  - **Load Balancer:**
    - Provisions a load balancer for application support
    - Typically cloud-provider only.

---

## NodePort

- Maps a port on the clsuter node to a port on the pod to allow accessibility
- On closer inspection, this service type can b e broken down into 3 parts:
  1. The port of the application on the pod it's running from -> `targetPort`
  1. The port on the service itself -> `port`
  1. Port on the node used to access the application externally -> `NodePort`

- **Note:** NodePort range only available for `30000 - 32767`

- To create the service, create a definition file similar to the following:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  ports:
  - targetPort: 80
    port: 80
    nodePort: 30080
```

- **Note:** The prior definition file is acceptable for using only one pod on the cluster.
  - If there are multiple pods with a `targetPort` of say 80 in this case, this will cause issues, the service needs to only focus on certain pods
  - This can be worked around via the use of selectors

- Under `selector`, add any labels associated with the pod definition file e.g.:

```yaml
selector:
  app: myapp
  type: frontend
```

- The service can then be created using `kubectl create -f <filename>.yaml` as per usual.

- To view services: `kubectl get services`

- To access the web service: `curl <node IP>:<node Port>`

- Suppose you're in a production environment:
  - Multiple pods or instances running in the same application
  - Allows high availability and load balancing

- If all pods considered share the same labels, the selector will automatically assign the pods as the service endpoints -> no additional configuration is required.

- If the pods are distributed across multiple nodes:
  - Without any additional configuration Kubernetes automatically creates the service to span the entire set of nodes in the cluster.
    - Maps the target port to the same node port for each node.
    - The application can be accessed through the IP of any of the nodes in the cluster, but via the same port.

- Regardless of the number of pods or nodes involved, the service creation method is exactly the same, no additional steps are required.

- **Note:** When pods are removed or added, the service will automatically be updated => offering higher flexibility and adaptability.