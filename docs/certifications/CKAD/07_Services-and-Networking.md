# 7.0 - Services and Networking

## 7.1 - Services

- Kubernetes services allows inter-component communication both within and outside Kubernetes.
- Additionally, services allow connections of applications with users or other applications.

### Example

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
  - Kubernetes service(s) can be introduced to map the request from a local machine -> node -> pod
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

### NodePort

- Maps a port on the cluster node to a port on the pod to allow accessibility
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
spec:
  ...
  selector:
    app: myapp
    type: frontend
  ...
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

## 7.2 - ClusterIP Service

- In general, a fill stack will comprise of groups of pods, hosting different parts of an application, such as:
  - Frontend
  - Backend
  - Key-value store

- Each of these groups of pods need to be able to interact with one another for the application to fully function.

- Each pod will automatically be assigned its own IP address
  - Not static
  - Pods could be removed or added at any given point
  - One cannot therefore rely on these IP addresses for inter-service communication

- Kubernetes ClusterIP services can be used to group the pods together by functionality and provide a single interface to access them.
  - Any requests to that group is assigned randomly to one of the pods within.

- This provides an easy and effective deployment of a microservice-based application on a Kubernetes cluster.

- Each layer or group gets assigned its own IP address and name within the cluster
  - To be used by other pods to access the service.
  - Each layer can scale up or down without impacting service-service communications

- To create, write a definition file:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: ClusterIP
  ports:
  - targetPort: 80
    port: 80
  selector:
    app: myapp
    type: backend
```

- To create the service: `kubectl create -f <service file>.yaml` or `kubectl expose <deployment or pod name> --port=<port> --target-port=<port> --type=clusterIP`

- View services via `kubectl get services`

- From here, the services can be accessed via the ClusterIP or service name.

## 7.4 - Ingress Networking

- To understand the importance of Ingress, consider the following example:
  - Suppose you build an application into a Docker image and deploy it as a pod via Kubernetes.
  - Due to the application's nature, set up a MySQL database and deploy a clusterIP service -> allows app-database communications.
- To expose the app or external access, one needs to create a NodePort service.
  - App can then be accessed via the Node's IP and the port defined.
- To access the URL, users need to go to `http://<node ip>:<node port>`
- This is fine for small non-production apps, it should be noted that as demand increases, the replicaSet and service configuration can be altered to support load balancing.

- For production, users wouldn't want to have to enter an IP and port number every time, typically a DNS entry would be created to map to the port and IP.
- As service node ports can only allocate high numbered ports (`> 30000`):
  - Introduce a proxy server between DNS cluster and point it to the DNS server.

- The above steps are applicable if hosting an app in an on-premise datacenter.
- If working with a public cloud application, NodePort can be replaced by `LoadBalancer`
  - Kubernetes still performs NodePort's functionality AND sends an additional request to the platform to provision a network load balancer.

- The cloud platform automatically deploys a load balancer configured to route traffic to the service ports of all the nodes.

- The cloud provider's load balancer would have its own external IP
  - User request access via this IP.

- Suppose as the application grows and a new service is to be added, it's to be accessed via a new URL.
  - For the new application to share the cluster resource, release it as a separate deployment.
  - Engineers could create a new load balancer for this app, monitoring a new port
    - Kubernetes automatically configures a new load balancer on the cloud platform of a new IP.

- To map the URLs between the 2 new services, one would have to implement a new proxy server on top of those associated with the service.
  - This proxy service would have to be configured and SSL communications would have to be enabled.

- This final proxy could be configured on a team-by-team basis, however would likely lead to issues.

---

- The whole process outlined above has issues, on top of having additional proxies to manage per service, one must also consider:
  - **Cost:** Each additional Load Balancer adds more expense.
  - **Difficulty of Management:** For each service introduced, additional configuration is required for both firewalls and proxies
    - Different teams required as well as time and "person" power.

- To work around this and collectively manage all these aspects within the cluster, one can use Kubernetes Ingress:
  - Allows users access via a single URL
  - URL can be configured to route different services depending on the URL paths.
  - SSL security may automatically be implemented via Ingress
  - Ingress can act as a layer 7 load balancer built-in to Kubernetes clusters
    - Can be configured to act like a normal Kubernetes Object.

- **Note:** Even with Ingress in place, one still needs to expose the application via a NodePort or Load Balancer -> this would be a 1-time configuration.

- Once exposed, all load balancing authentication, SSL and URL routing configurations are manageable and viewable via an Ingress Controller.

- Ingress controllers aren't set up by default in Kubernetes, example solutions that can be deployed include:
  - GCE
  - NGINX
  - Traefik

- Load balancers aren't the only component of an Ingress controller, additionaly functionalities are available for monitoring the cluster for new Ingress resources or definitions.

- To create, write a definition file:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      containers:
      - name: nginx-ingress-controller
        image: <nginx ingress controller url>
        args:
        - /nginx-ingress-controller
        - --configmap=$(POD_NAMESPACE)/nginx-configuration
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        ports:
        - name: http
          containerPort: 80
        - name: https
          containerPort: 443
```

- **Note:** As working with Nginx, need to configure options such as log paths, SSL settings, etc.
  - To decouple this from the controller image, write a separate config map definition file to be referenced:
    - Allows easier modification rather than editing one huge file.

- An ingress service definition file is also required to support external communicationL

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```

- The service NodePort definition above links the service to the deployment.

- As mentioned, Ingress controllers have additional functionality available for monitoring the cluster for ingress resources, and apply configurations when changes are made

- For the controller to do this, a service account must be associated with it:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
```

- The service account must have the correct roles and role-bindings to work.

- To summarise, for an ingress controller, the following resources are needed:
  - Deployment
  - Service
  - ConfigMap
  - ServiceAccount

- Once an ingress controller is in place, one can create ingress resources:
  - Ingress resources are a set of rules and configurations applied to an ingress controller, linking it to other Kubernetes objects.

- For example, one could configure a rule to forward all traffic to one application, or to a different set of applications based on a URL.
- Alternatively, could route based on DNS.
  - As per, ingress resources are configured via a destination file

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-cluster
spec:
  backend:
    serviceName: wear-service
    servicePort: 80
```

- **Note:** For a single backend like above, no additional rules are required.
- The ingress resource can be created via standard means i.e. `kubectl create -f ....`

- To view ingress resource: `kubectl get ingress`
- To route traffic in a conditional form, use ingress rules e.g. routing based on DNS
- Within each rule, can configure additional paths to route to additional services or applications.

- To implement, adhere to the principles outlined in the following 2-service example:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-cluster
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
            serviceName: wear-service
            servicePort: 80
      - path: /watch
        backend:
            serviceName: watch-service
            servicePort: 80
```

- Create the ingress resource using `kubectl create -f ...` as per usual.

- To view the ingress's detailed information: `kubectl describe ingress <ingress name>`

- **Note:** In the description, a default backend is described. <br> In the event a user enters a path not matching any of the rules, they will be redirected to that backend service (which must exist!).

- If wanting to split traffic via domain name, a definition file can be filled out as normal, but in the spec, the rules can be updated to point to specific hosts instead of paths:

```yaml
...
rules:
- host: <url 1>
  http:
    paths:
    - backend:
        serviceName: <service name 1>
        servicePort: <port 1>
- host: <url 2>
  http:
    paths:
    - backend:
        serviceName: <service name 2>
        servicePort: <port 2>
...
```

- When splitting by URL, had 1 rule and split the traffic by 2 paths
- When splitting by hostname, used 2 rules with a path for each.

- **Note:** If not specifying the host field, it'll assume it to be a `*` and / or accept all incoming traffic without matching the hostname
  - Acceptable for a single backend

### Updates and Additional Notes

- As of Kubernetes versions 1.20+, Ingress resources are defined a little differently, in particular the `apiVersion` and `service` parameters. An example follows:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-cluster
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
          service:
            name: wear-service
            port:
              number: 80
      - path: /watch
        backend:
          service:
            name: watch-service
            port:
              number: 80
```

- Ingress resources can be created imperatively via commands similar to: `kubectl create ingress <ingress-name> --rule="<host>/<path>=service:port"`

#### Rewrite-Target Option

- Different ingress controllers come with particular customization options. For example, NGINX has the `rewrite-target` option.
- To understand this, consider two services to be linked via the same ingress, accessible at the following urls for standalone services and via ingress respectively:
  - `http://<service 1>:<port>/` & `http://<service 2>:<port>/`
  - `http://<ingress-service>:<ingress-port>/<service 1 path>` & `http://<ingress-service>:<ingress-port>/<service 2 path>`

- The two applications will not have the paths defined in the ingress urls configured on them, without the `rewrite-target` configuration, the following journey would occur for each given service:
  - `http://<ingress-service>:<ingress-port>/<service 1 path>` -> `http://<service 1>:<port>/<service 1 path>`
- As the service paths aren't configured for the applications, this would throw an unexpected error. To avoid, one can use the `rewrite-target` option to rewrite the URL upon the ingress URL being called.
  - This will replace the content under `path` for the given `paths` with a value defined in a `rewrite-target` annotation. This is analogous to a `replace` function.
- This is implemented in a similar manner to below:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-cluster
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
          service:
            name: wear-service
            port:
              number: 80
      - path: /watch
        backend:
          service:
            name: watch-service
            port:
              number: 80
```

## 7.7 - Network Policies

### Traffic Example

- Suppose we have the following setup of servers:
  - Web
  - API
  - Database
- Network traffic will be flowing through each of these servers across particular ports, for example:
- Web user requests and receives content from the web server on port 80 for HTTP
- Web server makes a request to the API over port 5000
- API requests for information from the database over port 3306 (e.g. if MySQL)

- 2 Types of Network Traffic in this setup:
  - **Ingress:** Traffic to a resource
  - **Egress:** Traffic sent out from a resource

- For the setup above, we could control traffic by allowing ONLY the following traffic to and from each resource across particular ports:
  - **Web Server:**
    - Ingress: 80 (HTTP)
    - Egress: 5000 (API port)
  - **API Server:**
    - Ingress: 5000
    - Egress: 3306 (MySQL Database Port)
  - **Database Server:**
    - Ingress: 3306

- Considering this from a Kubernetes perspective:
  - Each node, pod and service within the cluster has its own IP address
  - When working with networks in Kubernetes, it's expected that the pods should be able to communicate with one another, regardless of the olution to the project
    - No additional configuration required
- By default, Kubernetes has an "All-Allow" rule, allowing communication between any pod in the cluster.
  - This isn't best practice, particularly if working with resources that store very sensitive information e.g. databases.
  - To restrict the traffic, one can implement a network policy.

---

- A network policy is a Kubernetes object allowing only certain methods of network traffic to and from resources. An example follows:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: network-policy
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector: # what pods can communicate with this pod?
        matchLabels:
          name: api-pod
      namespaceSelector: # what namespaced resources can communicate with this pod?
        matchLabels:
          name: prod
    - ipBlock: # what IP range(s) are allowed?
        cidr: 192.168.5.10/32
    ports:
    - protocol: TCP
      port: 3306
  egress:
  - to:
    - ipBlock: # what IP range(s) are allowed?
        cidr: 192.168.5.10/32

```

- The policy can then be created via `kubectl create -f ....`

- Network policies are enforced and supported by the network solution implemented on the cluster.
- Solutions that support network policies include:
  - `kube-router`
  - `calico`
  - `romana`
  - `weave-net`

- Flannel doesn't support Network Policies, they can still be created, but will not be enforced.
- Rules are separated by `-` in order of listing, in the example above, the conditions for `podSelector` and `namespaceSelector` must be met. If this isn't met, then the `ipBlock` condition would be checked.
- Similar syntax for `egress` policies are used with some slight tweaks e.g. replace `from` with `to`.
