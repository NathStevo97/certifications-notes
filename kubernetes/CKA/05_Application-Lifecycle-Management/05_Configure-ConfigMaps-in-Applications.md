# 5.5 - Configure ConfigMaps in Applications

- When there are multiple pod definition files, it becomes difficult to manage
environmental data
- This can info can be removed from the definition files and managed centrally via
ConfigMaps
- ConfigMaps used to pass configuration data as key-value pairs in Kubernetes
- When a pod is created, the configmap's data can be injected into the pod, making
the kvps available as environmental variables for the application within the
container
- Configuring the ConfigMap involves 2 phases:
  - Create the ConfigMap
  - Inject it to the Pod
- To create, can run either:
  - kubectl create configmap <configmap name>
  - kubectl create -f <configmap-definition>.yaml
- By using the first command specified above, you can immediately create key-value
pairs:

```shell
kubectl create configmap <configmap-name> --from-literal=<key>=<value> ... --from-literal=<key>=<value>
```
