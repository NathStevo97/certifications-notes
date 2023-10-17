# 4.1 - Monitor Cluster Components

- Suppose we want to monitor performance metrics relating to resource consumption
across a cluster or at a pod level, where we can analyse it
- There isn't any built-in solution for Kubernetes that satisfied this, but plenty of
third-party options like Prometheus and Dynatrace are available
- Heapster was one of the first solutions for this, but is now deprecated
  - Slimmed down version available via Metrics Server
  - One metrics server allowed per cluster
  - It's an in-memory solution, data isn't persisted to system storage
- To generate the metrics, a sub-component of the kublet, known as the container advisor (c-advisor) collects the metrics from the pods and exposes them via the Kubelet API
- If using minikube, the metrics-server can be deployed via: `minikube addons enable metrics-server`
- For all other kubernetes setups, the metrics server is enabled via downloading and applying the yaml files from the associated Github repository
- To collect metrics about a particular object, run: `kubectl top <object>`
  - Objects that can be monitored include pods, nodes and more
