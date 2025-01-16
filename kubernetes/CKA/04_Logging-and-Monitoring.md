# 4.0 - Logging and Monitoring

- [4.0 - Logging and Monitoring](#40---logging-and-monitoring)
  - [4.1 - Monitor Cluster Components](#41---monitor-cluster-components)
  - [4.2 - Managing Application Logs](#42---managing-application-logs)

## 4.1 - Monitor Cluster Components

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

## 4.2 - Managing Application Logs

- When running a docker container in the background, one can view the associated
logs of a container by running `docker logs -f <container ID>`
- For kubernetes, run `kubectl logs -f <pod name>` for a standalone container
  - For a pod with multiple containers, you must specify the container name you
want to view, append this to the end of the above command
