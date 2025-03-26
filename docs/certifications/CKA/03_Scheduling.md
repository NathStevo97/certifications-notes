# 3.0 - Scheduling

## 3.1 - Manual Scheduling

- When a pod is made available for scheduling, the Scheduler looks at the PODs definition file for the value associated with the field NodeName
- By default, NodeName's value isn't set and is added automatically when scheduling
- The scheduler looks at all pods currently on the system and checks if a value has been added to the NodeName field, any which do not are a candidate for scheduling.
- The scheduler identifies the best candidate for scheduling using its algorithm and schedules the pod onto that Node by adding the node's name to the NodeName field.
- This setting of the NodeName field value binds the Pod to the Node.
- If there is no scheduler to monitor and schedule the nodes, the pods will remain in a pending state.
- Pods can be manually assigned to nodes if a scheduler isn't present.
- This can be done by manually setting the pod's value for NodeName in the definition file.
- This can only be done before the pod is created for the first time, it cannot be done post-creation for a pre-existing pod
- To configure, as a child of the pod's Spec, add the field: `nodeName: <nodename>`
- Alternatively, you can assign a node by creating a binding object definition file to send a post request to the pod binding API; mimicking the scheduler's actions.

```yaml
apiVersion: v1
kind: Binding
metadata:
 name: nginx
target:
 apiVersion: v1
 kind: Node
 name: node02
```

- Once the binding definition file is written, a post request can be sent to the pod's binding API; with the data set to the binding object in a JSON format in a similar vein to:

```bash
curl --header "Content-Type:application/json" --request POST --data ‘{"apiVersion":"v1", "kind": "Binding" ...}

http://$SERVER/api/v1/namespaces/default/pods/$PODNAME/binding
```

## 3.2 - Labels and Selectors

- Built-In Kubernetes features used to help distinguish objects of similar nature from
one another by grouping them
- Labels are added under the metadata section, where an infinite number of labels
can be added to the Kubernetes object in a key value format
- To filter objects with labels, use the kubectl get command and add the flag --selector
followed by the key-value pair in the format `key=value`

```shell
kubectl get <object> --selector key=value
```

- Selectors are used to link objects to one another, for example, when writing a
replica set definition file, use the selector feature in the spec to specify the labels the
object should look for in pods to manage.
- The same can be applied to services to help identify what pods or deployments it is
exposing.
- Annotations - Used to record data associated with the object for integration
purposes e.g. version number, build name etc

## 3.3 - Taints and Tolerations

- Used to set restrictions regarding what pods can be scheduled on a node.
- Consider a cluster of 3 nodes with 4 pods preparing for launch:
  - The scheduler will place the pods across all nodes equally if no restriction applies

- Suppose now only 1 node has resources available to run a particular application:
  - A taint can be applied to the node in question; preventing any unwanted pods from being scheduled on it.
  - Tolerations then need to be applied to the pod(s) to specifically run on node 1

- Pods can only run on a node if their tolerations match the taint applied to the node.

- Taints and tolerations allow the scheduler to allocate pods to required nodes, such that all resources are used and allocated accordingly.

- **Note:** By default, no tolerations are applied to pods.

### Taints - Node

- To apply a taint: `kubectl taint nodes <nodename> key=value:<taint-effect>`
- The key-value pair defined could match labels defined for resources e.g `app=frontend`
- The taint effect determines what happens to pods that are intolerant to the taint, 1 of 3 possibilities can be specified:
  - `NoSchedule` - Pods won't be scheduled.
  - `PreferNoSchedule` - Try to avoid scheduling if possible.
  - `NoExecute` - New pods won't be scheduled, and any pre-existing pods intolerant to the taint are stopped and evicted.

### Tolerations - Pod

- To apply a toleration to a pod, one can look at the definition file
- In the spec section, add similar to the following:

```yaml
tolerations:
- key: app
  operator: "Equal"
  value: "blue"
  effect: "NoSchedule"
```

- Be sure to apply the same values used when applying the taint to the node.
- All values added need to be enclosed in " ".

### Taint - NoExecute

- Suppose Node1 is to be used for a particular application:
  - Apply a taint to node 1 with the app name and add a toleration to the pod running the app.
  - Setting the taint effect to `NoExecute` causes existing pods on the node that are intolerant to be stopped and evicted.

- Taints and tolerations are only used to restrict pod access to nodes.
- As there are no restrictions / taints applied to the other pods, there's a chance the app could still be placed on a different node(s).
- If wanting the pod to go to a particular node, one can utilise node affinity.

- **Note:** A taint is automatically applied to the master node, such that no pods can be scheduled to it.
  - View it via `kubectl describe node kubemaster | grep Taint`

## 3.4 - Node Selectors

- Consider a 3-node cluster, with 1 node having a larger resource configuration:
  - In this scenario, one would like the task/process requiring more resources to go to the larger node.
- To solve, can place limitations on pods
- This can be done via the `nodeSelector` property in the definition file:

```yaml
nodeSelector:
  size: node-label
```

- NodeSelectors require the node to be labelled: `kubectl label nodes <node name> <label key>=<key value>`

- When pod is created, it should be assigned to the labelled node so long as the resources allow it.

### Limitations of NodeSelectors

- NodeSelectors are beneficial for simple allocation tasks, but if more complex allocation is needed, Node Affinity is recommended, e.g. "go to either 1 of 2 nodes".

## 3.5 - Node Affinity

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

### Node Affinity Types

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

## 3.6 - Taints and Tolerations vs Node Affinity

- Consider a 5-cluster setup:
  - Blue Node: Runs the blue pod
  - Red Node: Runs the red pod
  - Green Node: runs the green pod
  - Node 1: To run the grey pod
  - Node 2: " "

- Applying a taint ot each of the coloured nodes to accept their respective pod
  - Tolerances are then are applied to the pods

- Need to apply a taint to node 1 and node 2 as the coloured pods can still be allocated to nodes where they're not wanted.

- To overcome, use Node Affinity:
  - Label nodes with respective colours
  - Pods end up in the correct nodes via use of Node Selector.

- There's a chance that the unwanted pods could still be allocated.

- A combination of taints and tolerations, and node affinity must be used.
  - Apply taints and tolerations to present unwanted pod placement on nodes
  - Use node affinity to prevent the correct pods from being placed on incorrect nodes.

## 3.7 - Resource Limits

- Consider a 3-node setup, each has a set amount of resources available i.e.:
  - CPU
  - Memory
  - Disk Space

- The Kubernetes scheduler is responsible for allocating pods to nodes
  - To do so, it takes into account the node's current resource allocation and the resources requested by the pod.
  - If no resources are available, the scheduler will hold the pod back for release
- Kubernetes automatically assumes a pod or container within a pod will require at least:
  - 0.5 CPU Units
  - 256Mi Memory

- If the pod or container requires more resources than allocated above, one can configure the pod definition file's spec, in particular, add the following under the `containers` list:

```yaml
resources:
  requests:
    memory: "1Gi"
    cpu: 1
```

### Resource - CPU

- Can be set from `1m` (1 micro) to as high as required / supported by the host system.
- 1 CPU = 1 AWS vCPU = 1 GCP Core = 1 Azure Core = 1 Hyperthread

### Resources - Memory

- Allocate within any of the following suffix for the givne purpose and the system's capabilities:

| Memory Metric | Shorthand Notation | Equivalency |
|---------------|--------------------|-------------|
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
    ....
  limits:
    memory: < value and unit>
    cpu: <number>
```

- The limits and requests are set for each pod and container
- If CPU overload occurs, CPU usage is "throttled" ont he node
- If repeated memory use is exceeded, the pod is terminated.

### Default Resource Requirements and Limits

- Naturally Kubernetes assumes containers request 0.5 units of CPU and 256Mi of memory
- These defaults can be configured to suit for each namespace within the Kubernetes cluster by setting a limitrange, which can be produced via a yaml definition file similar to:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range # keep memory and CPU limit ranges separate
spec:
  limits:
  - default:
      memory: 512Mi
      cpu: 1
    defaultRequest:
      memory: 256Mi
      cpu: 0.5
    type: Container
```

### Pod / Deployment Editing

- When editing an existing pod, only the following aspects can be edited in the spec:
  - Image (for containers and initcontainers)
  - activeDeadlineSeconds
  - Tolerations
- Aspects such as environment variables, service accounts and resource limits cannot
be edited easily, but there are ways to do it:
  - Editing the specification:
■ Run `kubectl edit pod <podname>` and edit the appropriate features
■ When saving to log the changes, if the feature cannot be edited for an
existing pod, the changes will be denied
■ A copy of the definition file with the changes will saved to a temporary
location, which can be used to recreate the pod with the changes once
the current version is deleted
  - Extracting and editing the yaml definition file:
■ Run `kubectl get pod <podname> -o yaml > <filename.yaml>`
■ Make the desired changes to the yaml file and delete the current
version of the pod
■ Create the pod again with the file
- When editing the deployment, any aspect of its underlying pods can be edited as the
pod template is a child of the deployment spec
  - When changes are made, the deployment will automatically delete and
create new pods to apply the updates as appropriate

## 3.8 - DaemonSets

- Daemonsets are similar in nature to replicasets, they provide assistance in the
deployment of multiple instances of a pod
- Daemonsets run only one instance of the pod per node
- Whenever a new node is added, the pod is automatically added to the node and vice
versa for when the node is removed
- Use cases of Daemonsets include monitoring and logging agents
  - Removes the need for manually deploying one of these pods to any new
nodes within the cluster
  - Kubernetes components such as Kube-Proxy could be deployed as a
Daemonset as one pod is required per cluster
■ Similar network solutions could also be deployed as a Daemonset
- Daemonsets can be deployed via a definition file, it's similar in structure to that of a
Replicaset, with the only difference being the Kind

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
    template:
      metadata:
        labels:
          app: monitoring-agent
      spec:
        containers:
        - name: monitoring-agent
          image: monitoring-agent
```

- To view daemonsets, use the kubectl get daemonsets command
- You can view the details of the daemonset with the kubectl describe command i.e. `kubectl describe daemonset <daemonset name>`
- Prior to Kubernetes v1.12, a Daemonset would work by manually setting the
nodename for each pod to be allocated, thus bypassing the scheduler
- Post Kubernetes v1.12, the Daemonset uses the default scheduler and Node Affinity
rules discussed previously to allocate the single pod to each node

## 3.9 - Static Pods

- Kubelet relies on the kube-apiserver for instructions on what pods to load on its
respective node
- The instructions are determined by the kube scheduler which was stored in the etcd
server
- Considerations must be made if any of the kube-api server, scheduler and etcd
server are not present, as a worst case scenario, suppose none of them are
available
- Kubelet is capable of managing a node independently to an extent
  - The only thing kubelet knows to do is to create pods, however in this
scenario there's no api server to feed it the instructions based on yaml
definition files
  - To work around this, you can configure the kubelet to read the pod definition
files from a directory on the server designated to store information about
pods
  - Once configured, the Kubelet will periodically check the directory for any new
files, where it reads the information and creates pods based on the
information provided
- In addition to creating the pods, the kubelet would take actions to ensure the pod
remains running, i.e.:
  - if a pod crashes, kubelet will attempt to restart it
  - if any changes are made to any files within the directory, the kubelet will
recreate the pod to cause the changes to occur
- Pods created in this manner, without the intervention of the API server or any other
aspects of a kubernetes cluster, are Static Pods
- Note: Only pods could be created in this manner, objects such as Deployments and
Replicasets cannot be created in this manner
- To configure the "Desginated Folder" for the kubelet to look in for pod definition
files, add the following option to the kubelet service file `kubelet.service`; note the
directory could be any directory on the system: `--pod-manifest-path=/etc/kubernetes/manifests`
- Alternatively, you could create a yaml file to specify the path the kubelet should look
at, i.e. `staticPodPath: /etc/Kubernetes/manifests`, which can be referenced by adding
the `--config=/path/to/yaml/file` to the service file
  - Note this is the kubeadm approach
- Once static pods are created, they can be viewed by docker ps (can't use kubectl due
to no api server)
- It should be noted that even if the api server is present, both static pods and
traditional pods can be created
- The api server is made aware of the static pods because when the kubelet is part of
a cluster and creates static pods, it creates a mirror object in the kube api server
  - You can read details of the pod but cannot make changes via the kubectl edit
command, only via the actual manifest
- Note: the name of the pod is automatically appended with the name of the node it's
assigned to
- Because static pods are independent of the Kubernetes control plane, they can be
used to deploy the control plane components themselves as pods on a node
  - Install kubelet on all the master nodes
  - Create pod definition files that use docker images of the various control
plane components (api server, controller, etcd server etc)
  - Place the definition files in the chosen manifests folder
  - The pods will be deployed via the kubelet functionality
  - Note: By doing this, you don't have to download the associated binaries,
configure services or worry about services crashing
- In the event that any of these pods crash, they will automatically be restarted by
Kubelet with them being a static pod
- Note: To delete a static pod, you have to delete the yaml file associated with it from
the path configured

### Static Pods vs Daemonsets

| Static Pods                                            | Daemonsets                                            |
|--------------------------------------------------------|-------------------------------------------------------|
| Created via Kubelet                                    | Created via Kube-API Server (Daemonset controller)    |
| Used to deploy control plane components as static pods | Used to deploy monitoring and logging agents on nodes |
| Ignored by Kube-Scheduler                              | Ignored by Kube-Scheduler                             |

## 3.10 - Multiple Schedulers

- The default scheduler has its own algorithm that takes into accounts variables such
as taints and tolerations and node affinity to distribute pods across nodes
- In the event that advanced conditions must be met for scheduling, such as placing
particular components on specific nodes after performing a task, the default
scheduler falls down
- To get around this, Kubernetes allows you to write your own scheduling algorithm to
be deployed as the new default scheduler or an additional scheduler
  - Via this, the default scheduler still runs for all usual purposes, but for the
particular task, the new scheduler takes over
- You can have as many schedulers as you like for a cluster
- When creating a pod or deployment, you can specify Kubernetes to use a particular
scheduler
- When downloading the binary for kube-scheduler, there is an option in he
kube-scheduler.service file that can be configured; --scheduler-name
  - Scheduler name is set to default-scheduler if not specified
- To deploy an additional scheduler, you can use the same kube-scheduler binary or
use one built by yourself
  - In either case, the two schedulers will run as their own services
  - It goes without saying that the two schedulers should have separate names
for differentiation purposes
- If a cluster has been created via the Kubeadm manner, schedulers are deployed via
yaml definition files, which you can then use to create additional schedulers by
copying the file
  - Note: customise the scheduler name with the --scheduler-name flag
- Note: The leader-elect option should be used when you have multiple copies of the
scheduler running on different master nodes
  - Usually observed in a high-availability setup where there are multiple master
nodes running the kube-scheduler process
  - If multiple copies of the same scheduler are running on different nodes, only
one can be active at a time
  - The leader-elect option helps in choosing a leading scheduler for activities, to
get multiple schedulers working, do the following:
■ If you don't have multiple master nodes running, set it to false
■ If you do have multiple masters, set an additional parameter to set a
lock object name
- This differentiates the new custom scheduler from the default
during the leader election process
- The custom scheduler can then be created using the definition file and deployed to
the kube-system namespace
- From here, pods can be created and configured to be scheduled by a particular
scheduler by adding the field schedulerName to its definition file
  - Note: Any pods created in this manner to be scheduled by the custom
scheduler will remain in a pending state if the scheduler wasn't configured
correctly
- To confirm the correct scheduler picked the pod up, use `kubectl get events`
- To view the logs associated with the scheduler, run: `kubectl logs <scheduler name> --namespace=kube-system`

## 3.11 - Configuring Scheduler Profiles

- Schedulers can be configured manually or set up via kubeadm
- Additional schedulers can be created via yaml files, which can then be configured
with naming and identifying the "leader" of the schedulers for high-availability
setups
- Advanced options are available, but are outside the scope of the course
