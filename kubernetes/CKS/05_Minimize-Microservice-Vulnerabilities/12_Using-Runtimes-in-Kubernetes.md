# 5.12 - Using Runtimes in Kubernetes

- Assuming gVisor is already installed on the nodes of a Kubernetes cluster, it can be used as the runtime for containers within easily.
- To do so, a runtimeclass Kubernetes object is required, which can be created using kubectl as usual. The handler should be a valid name associated with the given runtime / application.

```yaml
# gvisor.yaml

apiVersion: node.k8s.io/v1beta1
kind: RutnimeClass
metadata:
  name: gvisor
handler: runsc
```

- To specify the runtime to be used by the pod, add `runtimeClassName: <runtime class name>` to the pod spec
- To check if pods are running in this runtime, run `pgrep -a <container name>`
  - If no output is given, there is an isolation between the system and the container and it's running in the defined runtime as expected.
  - To check the runtime: `pgrep -a <runtime>`
