# 2.9 - Editing Existing Pods

- Given a pod definition file, one can edit it and use it create a new pod.
- If not given a pod definition file, one can extract it by <br> `kubectl get pod <pod name> -o yaml > file.yaml`
  - The extracted YAML file can then be edited and applied, either by deleting the pod and recreating it, or using `kubectl apply`
- Alternatively, one can use `kubectl edit <pod name>` to edit the live pod's properties
  - Some properties cannot be edited on live deployments - in this case it is advisable to delete and recreate the resource.
