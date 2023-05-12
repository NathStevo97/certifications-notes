# 6.5 - Jobs

- Containers are created with the aim of running a particular task or workload. Common examples include:
  - Web apps
  - Databases
  - Analytics
  - Image processing

- When creating a container to perform a particular jon, Kubernetes will want the container to "live forever".
- When a container completes its job it'll exit and its state will become "completed"
- By default, Kubernetes will continuously restart it as it views there to be a problem, despite this not being the case.

- To work around, one can configure the "restartPolicy" property of the pod
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
  - Use a job to runa  set of pods to complete a common goal

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

- To create jobs in parallel rather than sequentially, add `parralellism` property as a simpling to `completions`.
  - Creates `x` pods simultaneously (so long as the system can handle it)

- More recommended to use `parralellism` rather than sequential creation as this could create more pods than necessary.