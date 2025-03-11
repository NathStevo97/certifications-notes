# 3.2 - Commands and Arguments in Kubernetes

- The Ubuntu sleeper image can be defined in a YAML file for Kubernetes similar to the following:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <pod name>
spec:
  containers:
  - name: <container name>
    image: <image name>:<image tag>
    command: ["<command>"]
    args: ["<arg1>"]
```

- To add anything to be appended to the `docker run` command, one adds the a`args` attribute to the container spec.
- The pod can then be created through standard means such as `kubectl create -f <filenmame>.yaml`
- The Dockerfile's entrypoint is overwritten by the `command` atribute.

- **Note:** You cannot edit specifications of a pre-existing pod aside from:
  - `containers`
  - `initContainers`
  - `activeDeadlineSections`
  - `tolerations`

- Environmental variables, in general, cannot be edited, as well as service accounts and resource limits.
- If editing is required of these parameters, 2 methods are advised:
  1. `kubectl edit pod <pod name>`
      - Edit the properties desired
      - As outlined above, certain properties cannot be edited whilst a pod is "live" - if this happens, the requested changes to the YAML will be saved as a temporary definition.
      - Delete the original pod `kubectl delete pod <pod name>`
      - Recreate the pod from the temp definition file: `kubectl create -f <temp filename>.yaml`
  2. Extract the YAML of the pod via `kubectl get pod <pod name> -o yaml > <file name>.yaml`
     - Open the extracted YAML and edit as appropriate e.g. `vim <filename>.yaml`
     - Delete the original pod and recreate similar to the latter 2 steps of method 1.

- **Note:** If part of a deployment, change any instance of `pod` in the commands above to `deployment`.
- Any changes to deployments are automatically applied to the pods within.
