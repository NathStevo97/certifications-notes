# 5.1 - Security Contexts

- When running docker containers, can specify security standards such as the ID of
the user to run the container
- The same security standards can be applied to pods and their associated containers
- Configurations applied a pod level will apply to all containers within
- Any container-level security will override pod-level security
- To add security contexts, add securityContext to either or both the POD and
Container specs; where user IDs and capabilities can be set
  - Note: Capabilities are only supported at container level

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command: ["sleep", "3600"]
    securityContext:
      runAsUser: 1000
      capabbilities:
        add: ["MAC_ADMIN"]
```