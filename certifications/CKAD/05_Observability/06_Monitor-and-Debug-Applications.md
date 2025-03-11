# 5.6 - Monitor and Debug Applications

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

## Heapster vs Metrics

### Heapster

- One of the original projects for Kubernetes monitoring and analysis
- Now deprecated.

### Metrics-Server

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
