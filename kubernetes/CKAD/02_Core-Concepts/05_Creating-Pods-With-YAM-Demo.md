# 2.5 - Creating Pods with YAML: Demo

- To create YAML files, any editor will suffice
- All files end with `.yml` or `.yaml`
- Example definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: nginx-container
    image: nginx
```

- To deploy: `kubectl create -f <pod definition>.yaml`
- To verify deployment: `kubectl get pods`
