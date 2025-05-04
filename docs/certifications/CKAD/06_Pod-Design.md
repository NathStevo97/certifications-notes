# 6.0 - Pod Design

## 6.1 - Lablels, Selectors and Annotations

- Labels and selectors allow standardized categorization of resources or objects
  - Objects can then be filtered by the categories selected

- **Labels:** Properties attached to each item
- **Selectors:** Filter criteria for items based on labels
  - E.g. Kind: Pod
- Over time one could end up with thousands of objects in a cluster, including Pods, nodes, etc.
  - Need to filter and categorize them.
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
    - This is by supplying the desired labels under `selector` in the ReplicaSet spec, and the metadata labels in the ReplicaSet `template`.

### Annotations

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

## 6.3 - Rolling Updates and Rollbacks in Deployments

### Rollout and Versioning

- When first creating a deployment, a rollout is triggered
  - Rollout = Deployment Revision
- When future upgrades occur, a new rollout and therefore a new revision of the deployment is created.
- This functionality allows tracking of deployment changes
  - Allows rollback capability in the event of application failure.

### Rollout Commands

- View rollout status: `kubectl rollout status <deployment name>`
- View rollout history and versioning: `kubectl rollout history <deployment name>`

### Deployment Strategy

- There are multiple deployment strategies available for applications, such as:
  - **Recreate Strategy:**
    - When a new version of an application is ready, tear down all current instances at once
    - Deploy new version once 'current' version is unavailable
    - This method causes significant downtime

  - **Rolling Updates:**
    - Destroy current instance and upgrade with new version one at a time
    - Leads to a higher application availability
    - Upgrade appears to be "seamless"

### Kubectl Apply

- To update a deployment, apply the appropriate changes to the associated definition file e.g. could update the image used, labels, etc.
  - Apply the changes: `kubectl apply -f <definition>.yaml`

- Changes can also be applied via the CLI directly, though this would not update the base definition YAML: `kubectl set image deployment/<deployment name> <image name>=<image name>:<new tag>`

- Deployment strategies can be viewed in detail for a given deployment via `kubectl describe deployment <deployment name>`
- For **recreate** strategy, during the upgrade process, one will see the deployment is gradually scaled down to 0 instances and back again.
- For **rolling update**:
  - Scaled down individually, old version is scaled down, then new version is brought up, this repeats per replicas.

### Upgrades

- When a new deployment's created, a new replicaset is automatically created, hosting the desired number of replica pods.
- During an upgrade, a new replicaset is created
  - New pods with new application version added sequentially
  - At the same time, the "old" pods are gradually taken down

- Once upgraded, if a rollback is required: `kubectl rollout undo <deployment name>`

### Kubectl Run

- The command `kubectl run <deployment name> --image <image name>` will create a deployment
  - This method acts as an alternative to using a definition file
  - Using this method, the required replicaset and pods auto-created in the backend.
- **Note:** It's highly recommended to use a definition file for deployments for file editing and versioning.

### Command Summary

- Create: `kubectl create -f <filename>.yaml`
- Get: `kubectl get deployments`
- Update a deployment: `kubectl apply -f <filename>.yaml` or `kubectl set image <deployment> <image ID>=<image>:<tag>`

- Apply an update via changes in a definition file or use CLI flags. The latter doesn't update any associated definition files stored on the system.

- Rollout Status: `kubectl rollout status <deploymment name>`
- Rollout History: `kubectl rollout history <deployment name>`

- Rollback: `kubectl rollout undo <deployment name>`

### Additional Notes

- Get the history of a particular deployment revision: `kubectl rollout history deployment <name> --revision=<revision number>`
- When updating a deployment revision, append the `--record` flag to save the command used to cause the revision update, this will be stored in the `change-cause` field of the above command's output.
- To rollback to a specific revision: `kubectl rollout undo deployment <name> --to-revision=<revision number>`

## 6.5 - Jobs

- Containers are created with the aim of running a particular task or workload. Common examples include:
  - Web apps
  - Databases
  - Analytics
  - Image processing

- When creating a container to perform a particular job, Kubernetes will want the container to "live forever", default behavior for a replicaSet.
- When a container completes its job it'll exit and its state will become "completed"
- By default, Kubernetes will continuously restart it as it views there to be a problem, despite this not being the case.

- To work around, one can configure the `restartPolicy` property of the pod
  - By default, this is set to `always` but can be changed to `never` or `on failure`

- Example Usage:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: math-pod
spec:
  containers:
  - name: math-add
    image: ubuntu
    command: ['expr', '3', '+', '2']
  restartPolicy: Never
```

- In practice, there may be more than one pod processing the data simultaneously.
  - All pods need to complete their task and exit.

- ReplicaSets could be used to ensure identical sets of pods are created.
  - Use a job to run a set of pods to complete a common goal

- As usual, a pod definition file to describe the job is needed.
  - Additionally, need a job definition file to create it:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  template:
    spec:
      containers:
      - name: math-add
        image: ubuntu
        command: ['expr', '3', '+', '2']
    restartPolicy: Never
```

- As with replicasets and deployments, the spec of the job is defined by a template containing the pod definition's spec.

- To create: `kubectl create -f <job definition>.yaml`

- To view jobs and status: `kubectl get jobs`
  - Displays the number of desired and successful jobs

- To view pods associated with jobs: `kubectl get pods`
  - Status will show `completed` as Kubernetes didn't try to restart the pod

- To verify the output, use `kubectl logs <job id>`

- To delete the job and associated pods: `kubectl delete job <job name>`

- **Note:** In reality, the jobs included would be far more complex

- To run multiple instances / pods to complete the job, add the property `completions` should be added as a sibling to `template`.
  - Pods will be created sequentially as each are completed.

- To create jobs in parallel rather than sequentially, add `parralellism` property as a sibling to `completions`.
  - Creates `x` pods simultaneously (so long as the system can handle it)

- More recommended to use `parralellism` rather than sequential creation as this could create more pods than necessary.

## 6.6 - CronJobs

- A job that can be scheduled.
- Usually if a job was created via `kubectl create`, the job will run instantly
  - Not applicable for certain jobs e.g. logging

- To create a CronJob, can create a definition file similar to:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 3
      parralellism: 3
      template:
        spec:
          containers:
          - name: reporting-tool
            image: reporting-tool
      restartPolicy: Never
```

- **Note:** The format for the schedule property should adhere to: <br> `minute (0-59) hour (0-23) day (0-31) month (1-12) day (week, 0-6)`
- One can use `*` to act as a wildcard / "every" option.

- To create a CronJob: `kubectl create -f <cronjob>.yaml`

- To view CronJob: `kubectl get cronjob`
