# 5.3 - Commands and Arguments - Kubernetes

- Using the previously defined image, one can create a yaml definition file:

```yaml
apiVersion: v1
Kind: Pod
metadata:
  name: pod-name
spec:
  containers:
    name: container-name
    image: container-image
    command: ["command"]
    args: ["10"]
```

- To add anything to be appended to the docker run command for the container, add
args to the container spec
- Pod may then be created using the `kubectl create -f` command as per
- To override entrypoint commands, add "command" field to the pod spec
- To summarise, in Kubernetes Pod Specs:
  - command overrides Dockerfile entrypoint commands
  - args override Dockerfile CMD commands
- Note: You cannot edit specifications of a preexisting pod aside from:
  - Containers
  - Initcontainers
  - activeDeadlineSeconds
  - Tolerations