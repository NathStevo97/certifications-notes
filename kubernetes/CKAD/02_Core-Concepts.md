# 2.0 - Core Concepts

## 2.1 - Recap: Kubernetes Architecture

### Node

- A physical or virtual machine where Kubernetes is installed
- Containers are deployed to these nodes via the Kubernetes CLI.
- To avoid applications failing to run on a node, it's advised to have multiple nodes together or multiple replicase of an app.
  - This can support high-availability and fault-tolerance.

### Cluster

- A set of nodes grouped together
- In the event of one node or app failing, users can be redirected to another node; maintaining accessibility.
- Clusters therefore allow load balancing to be supported in Kubernetes.

### Master Node

- Watches over the worker nodes and orchestrates containers within the cluster.
- Other responsibilities include:
  - Cluster management
  - Storing information around cluster members, etc.
  - Monitoring node status
  - Managing per-node workloads.

### Cluster Components

#### API Server

- Acts as the frontend for Kubernetes
- User Management devices and CLI tools all go through the API server when interacting with the cluster.

#### ETCD Server

- Acts as a key store service
- Stores all data used to manage the cluster
- Responsible for implementing logs within the cluster -> Avoids master-master conflicts

#### Scheduler

- Distributes workloads or containers across nodes
- Looks for newly-created containers and assigns them to nodes accordingly

#### Controller

- The primary orchestrators
- Responsible for noticing and responding to node/container failure, etc.
- Makes decisions to bring up new containers to replace those that have vailed (or another appropriate action)

#### Container Runtime

- The underlying software used to run containers.

#### Kubelet

- The agent running on each node.
- Responsible for ensuring containers run on nodes as expected.

### Master vs Worker Node

- Worker nodes host containers and other associated resources.
  - Requires container runtime to be installed (typically Docker)
- Master Node has Kube-API server running
- Worker nodes need the Kubelet agent to interact with the API server:
  - Provides info regarding worker node status
  - Allows ability to carry out interactions / tasks requested by the master node
- ETCD key-value store found only on the master node for security purposes
- Controller and scheduler also found on master node only - the master node handles all orchestration and workload allocation tasks.

| Master Node          | Worker Node                     |
| -------------------- | ------------------------------- |
| kube-API server      | kubelet                         |
| etcd key-value store | container runtime (e.g. Docker) |
| Controllers          |                                 |
| Scheduler            |                                 |

### Kubectl

- Tool used to deploy and manage resources on a Kubernetes cluster
- Common command examples:

```shell

## Deploy application onto cluster

kubectl run hello-minikube

## View cluster-related information

kubectl cluster-info

## Get / display information about the nodes in a cluster

kubectl get nodes

```

## 2.2 - Docker vs ContainerD

### Background

- Began as the primary container runtime based on its enhanced user experience, Kubernetes was then introduced to orchestrate Docker containers ONLY.
- As Kubernetes grew in popularity, other container runtimes wanted to be able to work with Kubernetes.
- This led to the introduction of the **Container Runtime Interface (CRI)**.
- CRI allowed any vendor to work as a Container Runtime for Kubernetes, so long as they adhered to the **Open Container Initiative (OCI)** standards:
  - **imagespec** - standards for how a particular image is built.
  - **runtimespec** - standards for how a particular runtime should be developed.
- Docker wasn't built to support the CRI standards, to work around this, **dockershim** was introduced to support it as a container runtime interface in Kubernetes.
- Docker consists of multiple components in addition to the runtime, **runc** including:
  - API
  - CLI
  - VOLUMES
- The runtime for Docker, **runc**, ran by the daemon **containerd**, IS CRI compatible, and can be used outside of Docker on its own.
- Given this, maintaining Dockershim was deemed unnecessary, and Kubernetes support for it was therefore dropped from v1.24.

### ContainerD

- A standalone container runtime that can be installed without Docker.
- Comes with its own CLI tool `ctr` - advised only for debugging containerD and not much else.
- **Example commands:**
  - `ctr images pull docker.io/library/redis:alpine`
  - `ctr run <image url>:<tag> <container name>`

#### NerdCTL

- Provides a Docker-like CLI for containerD, supporting docker-compose and the latest features in containerD such as:
  - Encrypted images
  - Lazy Pulling
  - P2P Image Distribution
  - Image signing and verifying
  - Namespaces in Kubernetes

- **Comparing Docker and NerdCTL Commands:**

| Command Goal                         | Docker Command                                  | NerdCTL Command                                  |
|--------------------------------------|-------------------------------------------------|--------------------------------------------------|
| Run a container                      | `docker run --name redis redis:alpine`          | `nerdctl run --name redis redis:alpine`          |
| Run a container with typical options | `docker run --name webserver -p 80:80 -d nginx` | `nerdctl run --name webserver -p 80:80 -d nginx` |

#### CRIctl

- Provides a CLI for CRI-compatible container runtimes, installed separately to a given runtime.
- Used to inspect and debug container runtimes only, it does not do anything with running containers.
- Applicable to multiple runtimes.

- **Example commands:**
  - Pull an image: `crictl pull busybox`
  - List images: `crictl images`
  - Exec into a container: `crictl exec -i -t <container id> <command>`
  - List the logs of a container: `crictl logs <container id>`
  - Get Kubernetes pods: `crictl pods`

- Container runtime endpoints are called in the following priority by `crictl`:
  - `unix:///run/containerd/containerd.sock`
  - `unix:///run/crio/crio.sock`
  - `unix:///var/run/cri-dockerd.sock`

## 2.2 - Recap: Pods

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

## 2.4 - Recap: Pods with YAML

- Kubernetes uses YAML files as inputs for object creation e.g. pods, deployments, services.
- These YAML files always contain 4 key fields:
  - **apiVersion:**
    - Version of Kubernetes API used to create the object
    - Correct api version required for varying objects e.g. `v1` for Pods and Services, `apps/v1` for Deployments
  - **kind:**
    - type of object being created
  - **metadata:**
    - data referring to specifics of the object
    - Expressed as a dictionary
    - Labels: Children of metadata
      - Indents denote what metadata is related toa  child of a property
      - Used to differentiate pods
      - Any key-value pairs allowed in labels
  - **spec:**
    - specification containing additional information around the object
    - Written in a dictionary
    - `-` denotes first item in a dictionary

- To create a resource from YAML: `kubectl create -f <definition>.yaml`

- To view pods: `kubectl get pods`

- To view detailed info of a particular pod: `kubectl describe pod <pod name>`

## 2.5 - Creating Pods with YAML: Demo

- To create YAML files, any editor will suffice
- All files end with `.yml` or `.yaml`
- Example definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: nginx-container
    image: nginx
```

- To deploy: `kubectl create -f <pod definition>.yaml`
- To verify deployment: `kubectl get pods`

## 2.9 - Editing Existing Pods

- Given a pod definition file, one can edit it and use it create a new pod.
- If not given a pod definition file, one can extract it by <br> `kubectl get pod <pod name> -o yaml > file.yaml`
  - The extracted YAML file can then be edited and applied, either by deleting the pod and recreating it, or using `kubectl apply`
- Alternatively, one can use `kubectl edit <pod name>` to edit the live pod's properties
  - Some properties cannot be edited on live deployments - in this case it is advisable to delete and recreate the resource.

## 2.10 - ReplicaSets Recap

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

## 2.13 - Deployments Recap

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

## 2.17 - Namespaces

- A namespace is automatically created when a cluster is created
- They serve to isolate the cluster resources such that they aren't accidentally maniuplated.

- **Example:**
  - When developing an application, one can create a `Dev` and `Prod` namespace to keep resources isolated

- Each namespace can then have their own policies, detailing user access and controlm etc.
- Resource limits may also be namespace-scoped.

### DNS

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
- To switch context: `kubectl config set-context $(kubectl config current-context) --namespace=<namespace>`
- To view all pods in each namespace add `--all-namespaces` to the `get pods` commands.

### Resource Quota

- Creates limitations on resources for namespaces
- Created via definition file
- **Kind:** ResourceQuota
- **Spec:** must specify variables such as:
  - Pod numbers
  - Memory limits
  - CPU limits
  - Minimum requested/required CPU and Memory

- **Example:**

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
