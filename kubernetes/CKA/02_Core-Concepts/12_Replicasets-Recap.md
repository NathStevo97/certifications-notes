# 2.12 - Replicasets Recap

- Controllers monitor Kubernetes objects and respond accordingly
- A key one used is the replication controller
- Consider a single pod running an application:
  - If this pod crashes, the app becomes inaccessible
  - To prevent this, it'd be better to have multiple instances of the same app running simultaneously
- Replication controller allows the running of multiple instances of the same pod in the cluster; leading to higher availability
- **Note:** Even if there is a single pod, the replication controller will automatically replace it in the event of failure - this leans into the idea of the "desired state"; Kubernetes will ensure that the desired amount of replicas are available.

## Load Balancing and Scaling

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

## Labels and Selectors

- Consider a deployment of an application with 3 pods:
  - To create a replication controller or replicaset, one can ensure that at any given point, 3 pods will be running.
  - If the pods weren't created, the ReplicaSet will automatically create them.
  - ReplicaSet monitors the pods and deploys the replacements in the event of failure.

- The ReplicaSet knows what pods to monitor via labels
  - In the `matchLabels` parameter, the label entered denotes the pods the replicaset should manage.

- The template section is required such that the pod can be redeployed based on the template defined.

## Scaling

- To scale a Kubernetes deployment, one can update the `replicas` number in the `.yaml` file associated, and run `kubectl replace -f <definition>.yaml`
- Alternatively: `kubectl scale --replicas <new amount> <defintion>.yaml`
- Alternatively: `kubectl scale --replicas=<number> --replicaset <replicaset name>`
  - This method does not update the YAML file.

## Command Summary

- Create a ReplicaSet or object in KuberneteS: `kubectl create -f <definition>.yaml`
- List ReplicaSets: `kubectl get replicasets`
- Delete a replicaset and its underlying pods: `kubectl delete replicaset <replicaset name>`
- Replace or update the replicaset: `kubectl replace -f <replicaset definition>.yaml`
- Scale a replicaset: `kubectl scale --replicas=<number> -f <defintiion>.yaml`
