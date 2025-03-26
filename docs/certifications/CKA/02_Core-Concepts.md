# 2.0 - Core Concepts

## 2.1 - Cluster Architecture

Kubernetes exists to allow the hosting of containerized applications in an automated fashion, allowing communication between the different services associated, and facilitating the creation of however many instances you like.

**Master Node** - The node that manages, plans, schedules workloads and monitors worker nodes.

**Worker Nodes** - Nodes that host the containerised applications.

Master node is comprised of multiple tools/clusters, making up the control plane:

- **ETCD Cluster** - Stores information about worker nodes, such as containers running within.
- **Schedulers** - Identifies the appropriate nodes that a container should be allocated to depending on metrics such as resource requests, node affinity and selectors etc.
- **Controllers** - Tools responsible for monitoring and responding to node changes, such as optimizing the number of containers running, responding to faulty nodes etc.
- **Kube-API Server** - Orchestrates all operations within the cluster, exposes the Kubernetes API, which users use to perform management operations.
To run containers on the master and worker nodes, a standardized runtime environment is required, such as *Docker*.

On the worker nodes, tools included are:

- **Kubelet** - An engine on each node that carries out operations based on requests from the master node, occasionally sending statistic reports to the kube-apiserver as part of the monitoring
- **Kube-proxy** - Service that ensures ingress/egress rules are in place to allow inter-pod and node-node communications

## 2.2 - ETCD For Beginners

- ETCD Is a distributed reliable key-value store that is simple and fast to operate.
- Key-value store stores information ina key-value format, each value is associated with a
unique key and stored in a database.
- To install and run ETCD:

1. Download and extract the binaries from <https://github.com/etcd-io/etcd>
1. Run the associated executable `./etcd`

- This starts a service running on port 2379 by default.
- Clients can then be attached to the etcd service to store and retrieve information.
  - A default
client included is the etcd control client, a CLI client for etcd; used to store and retrieve key-value-pairs.

- To store a key-value-pair: `./etcdctl set <key> <value>`
- To retrieve a value: `./etcdctl get <key>`
- For additional information: `./etcdctl`

## 2.3 - ETCD In Kubernetes

- The etcd data store stores information relating to the cluster, such as:
  - Nodes
  - Pods
  - Configs
  - Secrets
  - Roles
- Every piece of information obtained from a kubectl get command is obtained from the etcd server.
- Additionally, any changes made to the cluster, such as adding nodes, deploying
pods or updating resources, the same changes are updated in the etcd server.
- Changes cannot be confirmed until the etcd server has been updated.
- The manner in which etcd is deployed is heavily dependent on your cluster setup. For the purposes of this course, 2 cases will be considered:
  - A cluster built from scratch
  - A cluster deployed using kubeadm
- Setting the cluster up from scratch requires manual downloading and installing the binaries; then configuring ETCD as a service in the master node.
- There are many options that can be added to this service, most of them relate to certificates, the rest describe configuring etcd as a cluster.
- One of the primary options to consider is the flag: `--advertise-client-urls https://${INTERNAL_IP}:2379`
- This defines the address which the ETCD service listens on, by default it's port 2379 on the IP of the server
  - It is in fact this URL that should be configured on the kube-api server when it attempts communication with the etcd server.
- If creating a cluster using kubeadm, the ETCD server is deployed as a pod in the kube-system namespace.
  - The database can then be explored using the etcdctl command within the pod, such as the following; which lists all the keys stored by kubernetes.

  ```shell
  kubectl exec etcd-mater -n kube-system etcdctl get / --prefix-keys-only
  ```

- The data stored on the etcd server adheres to a particular structure. The root is a registry containing various kubernetes resources e.g. pods, replicasets.
- In high-availability (HA) environments, multiple master nodes will be present, each containing their own ETCD instance.
  - In this sort of scenario, each instance must be made aware of another, which can be configured by adding the following flag in the etcd service file:

  ```shell
  --initial-cluster controller-0=https://${CONTROLLER0_IP}:2380, controller-1=https://${CONTROLLER1_IP}:2380, ...,
  controller-N=https://${CONTROLLERN_IP}:2380
  ```

## 2.4 - Etcd Common Commands

- ETCDCTL is the CLI tool used to interact with ETCD.
- ETCDCTL can interact with ETCD Server using 2 API versions - Version 2 and Version 3.
  - By default, it's set to use Version 2. Each version has different sets of commands.
- For example, ETCDCTL version 2 supports the following commands:

```shell
etcdctl backup
etcdctl cluster-health
etcdctl mk
etcdctl mkdir
etcdctl set
```

- Whereas the commands are different in version 3

```shell
etcdctl snapshot save
etcdctl endpoint health
etcdctl get
etcdctl put
```

- To set the right version of API set the environment variable `ETCDCTL_API` command `export ETCDCTL_API=3`

- When API version is not set, it is assumed to be set to version 2, therefore version 3 commands listed above don't work. And vice versa for when set to version 3.
- Apart from that, you must also specify path to certificate files so that ETCDCTL can authenticate to the ETCD API Server.
- The certificate files are available in the etcd-master at
the following path. We discuss more about certificates in the security section of this course. So don't worry if this looks complex:

```shell
--cacert /etc/kubernetes/pki/etcd/ca.crt
--cert /etc/kubernetes/pki/etcd/server.crt
--key /etc/kubernetes/pki/etcd/server.key
```

- So for the commands I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:

```shell
kubectl exec etcd-master -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get /
--prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key"
```

## 2.5 - Kube API Server

- The primary management component in Kubernetes
- When a kubectl command is ran, it is the Kube-API server that is contacted by the
kubectl utility for the desired action
- The kube-api-server authenticates and validates the request, then retrieves and
displays the requested information from the etcd server.
- Note: The kubectl command isn't always necessary to set the API server running.
  - Can instead send a post request requesting a resource creation such as:
■ `curl -X POST /api/v1/namespaces/default/pods ... [other]`
  - In this scenario, the following steps occur:
■ The request is authenticated
■ The request is validated
■ The API server creates a POD without assigning it to a node
■ Updates the information in the ETCD server and the user to inform of
the pod creation.
  - The updated information of the nodeless pod is acknowledged by the
scheduler; which monitors the API server continuously
■ The scheduler then identifies the appropriate node to place the pod
onto; communicating this back to the API server
  - The API server updates the ETCD server with this information and passes this
information to the kubelet in the chosen worker node
  - Kubelet agent creates the pod on the node and instructs the container
runtime engine to deploy the chosen application image.
  - Finally, the kubelet updates the API server with the change(s) in status of the
resources, which in turn updates the ETCD cluster's information.
- This pattern is loosely followed every time a change is requested within the cluster,
with the kube-api server at the centre of it all.
- In short, the Kube-api server is:
  - Responsible for validating requests
  - Retrieving and updating the ETCD data store
■ The API-Server is the only component that interacts directly with the
etcd data store
- Other components such as the scheduler and kubelet only use the API server to
perform updates in the cluster to their respective areas
- Note: The next point doesn't need to be considered if you bootstrapped your cluster
using kubeadm
  - If setting Kubernetes up "The Hard Way", the kube-apiserver is available asa
binary in the kubernetes release pages
  - Once downloaded and installed, you can configure it to run as a service on
your master node
- Kubernetes architecture consists of a lot of different components working with each
other and interacting with each other to know where they are and what they're
doing
  - Many different modes of authentication, authorization, encryption and
security, leading to many options and parameters being associated with the
API server.
- The options within the kube-apiserver's service file will be covered in detail later in
the notes, for now, the important ones are mainly certificates, such as:
  - `--etcd-certifile=/var/lib/kubernetes/kubernetes.pem`
  - `--kubelet-certificate-authority=/var/lib/kubernetes/ca.pem`
- Each of the components to be considered in this section will have their own
associated certificates.
- Note: To specify the location of the etcd servers, add the optional argument:
  - `--etcd-servers=https://127.0.0.1:2379`
■ Change IP address where appropriate or port, it's via this address the
kube-api-server communicates with the etcd server
- Viewing the options of the kube-api server in an existing cluster depends on how the
cluster was set up:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-apiserver.yaml`
  - Non-kubeadm setup:
■ Options displayed in kube-apiserver.service file at
/etc/systemd/system/kube-apiserver.service
■ Alternatively, use `ps -aux | grep kube-apiserver` to view the process
and its associated options

## 2.6 - Kube-Controller Manager

- The kubernetes component that manages each of the controllers within Kubernetes.
- Each controller has their own set of responsibilities, such as monitoring and
responding to changes in kubernetes resources or containers.
  - Continuous monitoring determined by "Watch Status"
  - Responsive actions carried out to "Remediate the situation"
- In terms of Kubernetes:
  - Controllers are processes that continuously monitor the state of various
components within the system
  - If any changes occur that negatively affect the system, the controllers work
towards bringing the system back to "normal"
- A common example of a controller us the node controller
  - Monitors the status of nodes in the cluster and takes responsive actions to
keep it running
- Any actions a controller takes are done via the kube-api server.
- The monitoring period for controllers can be configured and varies, for example the
node controller checks the status of the nodes every 5 seconds.
  - Allows frequent and accurate monitoring
  - If the controller cannot communicate with a node after 40 seconds, it's
marked as "Unreachable"
  - If after 5 minutes the node is still unreachable, the controller takes any pods
originally on the node and places them on a healthy available one.
- Another example is the replication controller
  - Responsible for monitoring the status of replicasets and ensuring that the
desired number of pods are available at all times within the set.
  - If a pod dies, it creates another.
- Many more controllers are found within Kubernetes, such as:
  - Deployments
  - CronJobs
  - Namespace
- All controllers are packaged as part of the Kube-Controller Manager; a single
process
- To install and view the Kubernetes Controller Manager. You can download and
extract the binary from the Kubernetes release page via wget etc, where you can
then run it as a service.
- When running the Kubernetes Controller Manager as a service, you can see that
there are a list of customisable options available.
  - Some options that are customizable include node monitor grace period,
monitoring period etc.
- You can also use the `--controllers` flag to configure and view what controllers you're
using.
- As with the Kube-API Server, the way you view the options on the Kube-Controller
Manager depends on your cluster's setup:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-controller-manager.yaml`
  - Non-kubeadm setup:
■ Options displayed in `kube-controller-manager.service`file at
`/etc/systemd/system/kube-apiserver.service`
■ Alternatively, use `ps -aux | grep kube-controller-manager` to view
the process and its associated options.

## 2.7 - Kube-Scheduler

- Responsible for scheduling pods on nodes i.e. identifying the best node for objects
such as pods and deployments to be placed on.
- It's a common misconception that the scheduler is responsible for actually placing
the resources onto the nodes, this is actually Kubelet's responsibility.
- A scheduler is needed to ensure that containers and resources end up on the nodes
that can successfully accommodate them based on certain criteria:
  - Resource requirements for pod
  - Resource capacity/quota for nodes
- The scheduler follows the 2-step process to make its decision:
  - Filters nodes that don't fit the resource requirements for the pod/object
  - Uses a priority function to determine which of the remaining nodes is the
best fit for the object based on the node's resource capacity, scoring from
0-10.
■ For example, if a pod requiring 10 cpu units could be placed on a
node with 12 total units or 16, it's preferable to place it on the 16-unit
one as this leaves more space for additional objects to be deployed to
the pod.
- The scheduler also utilises other tools such as taints and tolerations, and node
selectors/affinity.
- To install the kube-scheduler, extract and run the binary from the release page as a
service; under the file kube-scheduler.service, where you can configure the options
as per usual.
- As with the Kube-API Server, the way you view the options on the Kube-Scheduler
depends on your cluster's setup:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-scheduler.yaml`
  - Non-kubeadm setup:
■ Options displayed in `kube-scheduler.service` file at
`/etc/systemd/system/kube-scheduler.service`
■ Alternatively, use `ps -aux | grep kube-scheduler` to view the process
and its associated options.

## 2.8 - Kubelet

- Kubelet registers nodes and other objects within Kubernetes to their required
places on a cluster.
- When it receives instructions from the kube-scheduler via the kube-api server to
load a container, pod etc on the node, it requests the container runtime (usually
Docker), to pull the required image.
- Once the request is made, it continues to periodically monitor the state of the pod
and the containers within, reporting its findings to the kube-apiserver.
- When installing the kubelet, it must be noted that if setting up a cluster via
kubeadm, the kubelt isn't automatically deployed.
  - This is a KEY difference.
  - You must always manually install the kubelet on your worker nodes.
- To install, download the binary from the release page, from which you can extract
and run it as a service under `kubelet.service`
- The associated options can be viewed by either:
  - `/etc/systemd/system/kubelet.service`
■ Options can be configured within the file
  - `ps -aux | grep kubelet`

## 2.9 - Kube-Proxy

- In a cluster, every pod can interact with one another as long as a Pod Networking
solution is deployed to the cluster
  - Pod Network - An internal virtual network across all nodes within the cluster,
allowing any pod within the cluster to communicate with one another
- There are multiple solutions for deploying a pod network.
  - In one scenario, suppose you have a web application and a database running
on two separate nodes.
  - The two instances can communicate with each other via the IP of the
respective pods.
- In the example above, the problem arises when the IP of the pods aren't static, to
work around this, you can expose the pods across the cluster via a service.
- The service will have its own static IP address, so whenever a pod is to be accessed
or communicated with, communications are routed through the service's IP address
to the pod it's exposing.
- Note: The service cannot join the pod network as it's not an actual component, more
of an abstraction or virtual component.
  - It's not got any interfaces or an actively listening process.
- Despite the note, the service needs to be accessible across the cluster from any
node. This is achieved via the Kube-Proxy.
- Kube-Proxy: A process that runs on each node in the kubernetes cluster.
- The process looks for new services continuously, creating the appropriate rules on
each node to forward traffic directed to the service to the associated pods.
- To allow the rule creation, the Kube-Proxy uses IPTables rules.
  - Kube-Proxy creates an IP Tables rule on each node within the cluster to
forward traffic heading to the specific service to the designated pod; almost
like a key-value-pair.
- To install, download the binary from the release page, from which you can extract
and run it as a service under kube-proxy.service
- The kubeadm tool deploys kube-proxy as a PODs on each node
  - Kube-Proxy deployed as a Daemon Set, a single POD is always deployed on
each node in the cluster.

## 2.10 - Pods Recap

- Kubernetes doesn't deploy containers directly to nodes, they're encapsulated into Pods; a Kubernetes object.
- **Pod:** A single instance of an application
  - A pod is the smallest possible object in Kubernetes

- Suppose a containersied app is running on a single pod in a single node. If the user demand increases, how is the load balanced?
- One cannot have multiple containers to a pod
- Instead, a new pod will be required with a new instance of the application
- If the user demand increases further, but no pods are available on the node; a new node has to be created.

- In general, pods and containers have a 1-to-1 relationship.

### Multi-Container Pods

- A single pod can contain more than 1 container, however it cannot be running the same application.
- In some cases, one may have a "helper" container running alongside the primary application
  - The helper container usually runs support processes such as:
    - Process user-entered data
    - Carry out initial configuration
    - Process uploaded files
  - When new pod is created, an additional helper-container will automatically be created alongside it.
  - App and helper container communicate and share resources across a shared network
  - The two containers have a 1-to-1 relationship.

### Example Kubectl Commands

- `kubectl run <container name>`
  - Runs docker container by creating a pod
  - To specify image, append `--image <image name>:<image tag>`
  - Image will then be pulled from DockerHub

- `kubectl get pods`
  - Return a list detailing the pods in the default namespace
  - Append `--namespace <namespace>` to specify a namespace.

## 2.11 - Pods with YAML Recap

- Kubernetes uses YAML files as inputs for object creation e.g. pods, deployments, services.
- These YAML files always contain 4 key fields:
  - apiVersion:
    - Version of Kubernetes API used to create the object
    - Correct api version required for varying objects e.g. `v1` for Pods and Services, `apps/v1` for Deployments
  - kind:
    - type of object being created
  - metadata:
    - data referring to specifics of the object
    - Expressed as a dictionary
    - Labels: Children of metadata
      - Indents denote what metadata is related toa  child of a property
      - Used to differentiate pods
      - Any key-value pairs allowed in labels
  - spec:
    - specification containing additional information around the object
    - Written in a dictionary
    - `-` denotes first item in a dictionary

- To create a resource from YAML: `kubectl create -f <definition>.yaml`

- To view pods: `kubectl get pods`

- To view detailed info of a particular pod: `kubectl describe pod <pod name>`

## 2.12 - Replicasets Recap

- Controllers monitor Kubernetes objects and respond accordingly
- A key one used is the replication controller
- Consider a single pod running an application:
  - If this pod crashes, the app becomes inaccessible
  - To prevent this, it'd be better to have multiple instances of the same app running simultaneously
- Replication controller allows the running of multiple instances of the same pod in the cluster; leading to higher availability
- **Note:** Even if there is a single pod, the replication controller will automatically replace it in the event of failure - this leans into the idea of the "desired state"; Kubernetes will ensure that the desired amount of replicas are available.

### Load Balancing and Scaling

- The replication controller is needed to create replicas of the same pod and share the load across it.
- Consider a single pod serving a single user:
  - If a new user wants to acces the service, the controller automatically deploys an additional pod(s) to balance the load
  - If demand exceeds node space, the controller will create additional pods on other available node(s) in the cluster automatically

- One can therefore see the replication controller spans multiple nodes
  - It helps to balance the load across multiple pods on different nodes and supports scalability.

- In terms of the replication controller, 2 terms are considered:
  - Replication Controller
  - Replica Set

- ReplicaSet is the newer technology for the role of Replication Controller

- Replication controllers are defined in YAML format similar to the following:

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: frontend
spec:
  replicas: <replica number>
  template:
    metadata:
      <pod metadata>
    spec:
      <pod spec>
```

- There are 2 definition files posted, the replication controller's definition being a "parent" of the pod's definition file.
- The replication controller is created in standard practice via `kubectl create -f <filename>.yaml`
- To view the RC: `kubectl get replicationcontroller`
  - Displays the number of desired, currently available, and ready pods for associated replication controllers.
- Pods are still viewable via `kubectl get pods`

- ReplicaSet example definition:

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
  labels:
    app: myapp
    type: frontend
spec:
  template:
    metadata:
      <pod metadata>
    spec:
      <pod spec>
  selector:
    matchLabels:
      type: frontend
```

- Selectors ghelp replicasets determine what pods to focus on
  - This is required as replicasets can also manage pods not created or associated with the replicaset - so long as the labels match the selectr.
- Selectors are the main difference between ReplicaSets and ReplicationControllers
  - If not defined, it will assume the same lable provided in the pod definition file
- Creation done via `kubectl create -f <filename>.yaml` as per usual
- Pods can be checked via `kubectl get pods`

### Labels and Selectors

- Consider a deployment of an application with 3 pods:
  - To create a replication controller or replicaset, one can ensure that at any given point, 3 pods will be running.
  - If the pods weren't created, the ReplicaSet will automatically create them.
  - ReplicaSet monitors the pods and deploys the replacements in the event of failure.

- The ReplicaSet knows what pods to monitor via labels
  - In the `matchLabels` parameter, the label entered denotes the pods the replicaset should manage.

- The template section is required such that the pod can be redeployed based on the template defined.

### Scaling

- To scale a Kubernetes deployment, one can update the `replicas` number in the `.yaml` file associated, and run `kubectl replace -f <definition>.yaml`
- Alternatively: `kubectl scale --replicas <new amount> <defintion>.yaml`
- Alternatively: `kubectl scale --replicas=<number> --replicaset <replicaset name>`
  - This method does not update the YAML file.

### Command Summary

- Create a ReplicaSet or object in KuberneteS: `kubectl create -f <definition>.yaml`
- List ReplicaSets: `kubectl get replicasets`
- Delete a replicaset and its underlying pods: `kubectl delete replicaset <replicaset name>`
- Replace or update the replicaset: `kubectl replace -f <replicaset definition>.yaml`
- Scale a replicaset: `kubectl scale --replicas=<number> -f <defintiion>.yaml`

## 2.13 - Deployments

- When deploying an application in a production environment, like a web server:
  - Many instances of the web server could be needed
  - Need to be able to upgrade the instances seamlessly one-after-another (rolling updates)
  - Need to avoid simultaneous updates as this could impact user accessibility

- In the event of update failure, one should be able to rollback upgrades to a previously working iteration

- If wanting to make multiple changes to the environment, can pause each environment to make the changes, and resume when updates are in effect.

- These capabilities are provided via Kubernetes Deployments.
- These are objects higher in the hierarchy than a ReplicaSet
  - Provides capabilities to:
    - Upgrade underlying instances seamlessly
    - Utilise rolling updates
    - Rollback changes during failure
    - Pause and resume environments to allow changes to take place.

- As usual, Deployments can be defined by YAML definitions:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: frontend
spec:
  template:
    metadata:
      name: myapp-prod
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
      - name: nginx-controller
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: frontend
```

- To create deployment: `kubectl create -f <deployment>.yaml`
- View deployments: `kubectl get deployments`

- Other commands: `kubectl get all` -> Display all Kubernetes objects

## 2.14 - General Tips

- When using the CLI, it can become difficult to create and edit the YAML files
associated with objects in Kubernetes
- A quick alternative is to copy and paste a template file for the designated object and
edit it as required, in Linux Distributions this can be done via:
  - `CTRL+Insert = Copy`
  - `SHIFT+Insert= = Paste`
- Alternatively, the kubectl run command can be used to generate a YAML template
which can be easily modified, though in some cases you can get away with using
kubectl run without creating a new YAML file, such as the following examples.

```shell
# Creating an NGINX Pod

kubectl run nginx --image=nginx

# Creating an NGINX Deployment

kubectl create deployment --image=nginx nginx
```

- In cases where a YAML file is needed, one can add the `--dry-run` flag to the kubectl
run command and direct its output to a YAML file
- The `--dry-run=client` flag signals to Kubernetes to not physically create the object
described, only generate a YAML template that describes the specified object

```shell
# Create an NGINX Pod YAML without Deploying the Pod

kubectl run nginx --image=nginx --dry-run=client -o yaml > nginx-pod.yaml

# Create a deployment YAML

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

# Create a deployment YAML with specific replica numbers:

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```

## 2.15 - Namespaces

- A namespace is automatically created when a cluster is created
- They serve to isolate the cluster resources such that they aren't accidentally maniuplated.

- **Example:**
  - When developing an application, one can create a `Dev` and `Prod` namespace to keep resources isolated

- Each namespace can then have their own policies, detailing user access and controlm etc.
- Resource limits may also be namespace-scoped.

### Domain Name Service - DNS

- For objects communicating in their namespace, they simply refer to the other object by their name.
- Example, for a web application pod connecting to a database service titled `db-service`, you would specify: `mysql.connect("db-service")`.
- For objects communicating outside of their namespace, need to append the name of the namespace to access and communicate.
  - Example: `mysql.connect("db-service.dev.svc.cluster.local")`
  - In general format followed: `<service name>.<namespace>.svc.cluster.local`
- This can be done as when a service is created, a DNS entry is added automatically in this format.
- `cluster.local` is the default cluster's domain name.
- `svc` = subdomain for service.
- List all pods in default namespace: `kubectl get pods`
- List all pods in specific namespace: `kubectl get pods --namespace <namespace>`
- When creating a pod via a definition file, it will automatically be added to the default namespace if no namespace is specified.
- To add to a particular namespace: `kubectl create -f <definition>.yaml --namespace=<namespace name>`

- To set default namespace of a pod, add `namespace: <namespace name>` to metadata in the definition file.

- Namespaces can be created via YAML definitions:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: namespace-name
```

- To create: `kubectl create -f <namespace>.yaml`
- Alternatively: `kubectl create namespace <namespace name>`
- To switch context: `kubectl config set-context $(kubectl config current-context --namespace=<namespace>)`
- To view all pods in each namespace add `--all-namespaces` to the `get pods` commands.

### Resource Quota

- Creates limitations on resources for namespaces
- Created via definition file
- Kind: ResourceQuota
- Spec must specify variables such as:
  - Pod numbers
  - Memory limits
  - CPU limits
  - Minimum requested/required CPU and Memory

- Example:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
```

## 2.16 - Services

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

### NodePort

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

## 2.17 - ClusterIP Services

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

## 2.18 - LoadBalancer Services

- Kubernetes service type that helps balance traffic routing to underlying services and nodes within the cluster.
- Only supported on separate cloud platforms such as GCP, Azure etc
- Unsupported in environments such as Virtualbox, if still used, it basically has the same effect as a service of type NodePort.

## 2.19 - Imperative vs Declarative Commands

- Imperative: The use of statements to change a programs state, give a program
step-by-step instructions on how to perform a task, specify the "how" to get to the
"what"
- Declarative: Writing a program describing an operation by specifying only the end
goal, specify the "what" only
- In Kubernetes, this split in programming language can be broken down as:
  - Imperative - Using kubectl commands to perform CRUD operations like
scaling and updating images, as well as operations with .yaml definition files.
■ These commands specify the exact commands and how they should
be performed.
  - Declarative:
■ Using kubectl apply commands with definition files, Kubernetes will
consider the information provided and determine what changes need
to be made
- Imperative commands in kubernetes include:
  - Creation
■ Run
■ Create
■ Expose
  - Update Objects
■ Edit
■ Scale
■ Set (image)
- It should be noted that Imperative commands are often "one-time-use" and are
limited in functionality, for advanced operations it's better to work with definition
files, and that's where using the `-f <filename>` commands are better-used.
- Imperative commands can become taxing as they require prior knowledge of
pre-existing configurations, which can result in extensive troubleshooting if
unfamiliar.
- For the declarative approach, it's more recommended to use this when making
extensive changes or updates without having to worry about manual
troubleshooting or management.

## 2.20 - Kubectl Apply
