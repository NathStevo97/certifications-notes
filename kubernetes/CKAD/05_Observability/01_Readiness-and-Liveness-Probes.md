# 5.1 - Readiness and Liveness Probes
- Pod lifecycles are defined by 2 parameters:
  - Status
  - Conditions

- Status determines Pod lifecycle stage
  - Pending (Until Scheduled)
  - ContainerCreating (Once Scheduled)
  - Running (Once Container Running)

- Status may be viewed by `kubectl get pods`
- For additional information, consider Pod conditions:
  - A set of True/False conditions to determine lifecycle stage:
    - PodScheduled
    - Initialized
    - ContainersReady
    - Ready

- In some scenarios, the service provided by a container may take additional time to load beynd the pod being declared "Ready".
- This can cause issues as if a service isn't fully ready, but Kubernetes deems it to be, Kubernetes will automatically route traffic to the pod.
- By default, Kubernetes assumes services to be ready as sson as the associated container is ready, not the associated services.
- If the application isn't ready, the users will be requesting to an unavailable pod.
- To fix, one needs to change the readiness condition to suit the application within the container, this is defined by **Readiness Probes**

- Various types of readiness probes can be configured:
  - HTTP Test e.g `/api/ready` (Web Server)
  - TCP Test - Port 3306 (Check connection to MySQL Database)
  - Exec command in container => Exit if successful

- To configure a readiness probe, add to the container's spec in the pod in a similar manner to:

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
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```

- Now, when the pod is deployed and the container is created, the pod's "READY" status is determined as to whether the HTTP call to the defined path returns a positive response.

- Sample TCP readiness probe:

```yaml
readinessProbe:
  tcpSocket:
    port: 3306
```

- For a command execution:

```yaml
readinessProbe:
  exec:
    command:
    - cat
    - /app/is_ready
```

- **Note:** To allow for additional time before the test occurs, add as a sibling to the test type: `initialDelaySeconds: 10`

- **Note:** To configure the time period between checks: `periodSeconds: 5`

- By default,the probe will stop after 3 attempts. To configure: `failureThreshold: 5`
- Readiness probes become beneficial when using a multi-pod configuration
  - If demand increases, additional pods will be needed
  - If pods don't use readiness probes, false deployment occurs -> leading to service disruption.