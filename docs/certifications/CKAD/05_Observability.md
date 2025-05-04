# 5.0 - Observability

## 5.1 - Readiness and Liveness Probes

- Pod lifecycles are defined by 2 parameters:
  - `Status`
  - `Conditions`

- Status determines Pod lifecycle stage
  - `Pending` (Until Scheduled)
  - `ContainerCreating` (Once Scheduled)
  - `Running` (Once Container Running)

- Status may be viewed by `kubectl get pods`
- For additional information, consider Pod conditions:
  - A set of True/False conditions to determine lifecycle stage:
    - `PodScheduled`
    - `Initialized`
    - `ContainersReady`
    - `Ready`

- In some scenarios, the service provided by a container may take additional time to load beyond the pod being declared "Ready".
- This can cause issues as if a service isn't fully ready, but Kubernetes deems it to be, Kubernetes will automatically route traffic to the pod.
- By default, Kubernetes assumes services to be ready as soon as the associated container is ready, not the associated services.
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

## 5.2 - Liveness Probes

- Suppose you run an `nginx` docker image and is serving users:
  - In the event of this container failing, the service will stop, and will remain stopped until restarted; as Docker is not an orchestration tool.
- This problem can be fixed via Kubernetes' orchestration. During application failure, Kubernetes will always try to restart failed containers to minimize user downtime.
- This will work fine so long as it's not an application-level issue.
  - If the container is working but the issue is at an application level, Kubernetes will see no issue. This is not good for user experience.

- To work around this, Liveness Probes can be leveraged to periodically test the application's health.

- If the test fails, the container is destroyed and recreated
- Test could be:
  - HTTP Test: Check a given route e.g. `/api/healthy`
  - TCP Test: Check connection to a given port e.g. 3306 (MySQL)
  - Exec a command and check the result

- As with readiness probe, configure the liveness probe in the pod's definition file for the particular container:

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
    livenessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```

- Sample TCP liveness probe:

```yaml
livenessProbe:
  tcpSocket:
    port: 3306
```

- For a command execution:

```yaml
livenessProbe:
  exec:
    command:
    - cat
    - /app/is_ready
```

- Additionally, as with readiness probes, one can add parameters such as:
  - How long the test should wait before starting: `initialDelaySeconds`
  - How often should the test run: `periodSeconds`
  - How many successive failures are allowed: `failureThreshold`

## 5.4 - Container Logging

### Logs - Docker

- When running a container there are 2 main options:

1. Live / Forefront
    - `docker run <image>`
    - Displays live logs and processes associated with the container.
    - Good for testing standalone containers
2. Detached / Background
    - Recommended
    - `docker run -d <image>`

- To view the logs associated with the detached container and stream them: `docker logs -f <container id>`

### Logs - Kubernetes

- When running a pod in Kubernetes, you can view the container's logs via: `kubectl logs -f <pod name>`
- This only works for 1 container, what about 2?
  - Error will occur
  - To view specific container logs within a pod, run the above command and append the container name i.e. `kubectl logs -f <pod name> <container name>`.

## 5.6 - Monitor and Debug Applications

- When monitoring a cluster, one would like to monitor metrics such as:
  - Node metrics:
    - No. of nodes
    - How many nodes are healthy
  - Performance metrics:
    - CPU Usage
    - Memory Usage
    - Disk Utilization
  - Pod metric levels:
    - Pod numbers
    - Pod performance levels

- Need to monitor, store and analyze these metrics.
- This is not automatically done by Kubernetes, it lacks the functionality.

- Additional tools are available for this, such as Prometheus Metrics Server.
- Note: For this course, only a minimum knowledge of these tools is required:
  - Consider metrics server for now.

---

### Heapster vs Metrics

#### Heapster

- One of the original projects for Kubernetes monitoring and analysis
- Now deprecated.

#### Metrics-Server

- A slimmed-down version of Heapster

---

- 1 metrics server can be deployed per Kubernetes cluster
- It retrieves metrics from cluster nodes and pods, storing them in-memory
  - Metrics server is therefore an in-memory monitoring solution.
  - Any data stored isn't stored on-disk
    - One cannot view historical data, another tool is required e.g. Prometheus

- Kubernetes runs an agent on each node called Kubelet
  - Kubelet is responsible for receiving instructions from the Kubernetes API on the Master Node
  - It is also responsible for running pods on nodes.

- Kubelet contains sub-components called cAdvisor (container advisor)
  - Responsible for retrieving performance metrics from pods
  - The metrics are exposed through the Kubelet API to be accessed via the Metrics Server

- If running minikube, enable via `minikube addons enable metrics-server`
- If using another environment: <br>
  `git clone <link to metrics server repo>` <br>
  `kubectl create -f /path/to/deployments`

- **Note:** The create command above deploys a set of resources to enable metric collation by the metrics server.
- Once the data is processed, view analytics via either:
  - `kubectl top node` (Node Metrics)
  - `kubectl top pod` (Pod Metrics)
