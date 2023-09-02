# 2.13 - Deployments Recap

- When deploying an application in a production environment, like a web server:
  - Many instances of the web server could be needed
  - Need to be able to upgrade the instances seamlessly one-after-another (rolling updates)
  - Need to avoid simultaneous updates as this could impact user accessibility

- In the event of update failure, one should be able to rollback upgrades to a previously working iteration

- If wanting to make multiple changes to the environment, can pause each environment to make the changes, and resume when updates are in effect.

- These capabilities are provided via Kubernetes Deployments.
- These are objects higher in the hierarchy than a ReplicaSet
  - Provides capabilities to:
    - Upgrade underlying instances seamlessly
    - Utilise rolling updates
    - Rollback changes during failure
    - Pause and resume environments to allow changes to take place.

- As usual, Deployments can be defined by YAML definitions:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: frontend
spec:
  template:
    metadata:
      name: myapp-prod
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
      - name: nginx-controller
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: frontend
```

- To create deployment: `kubectl create -f <deployment>.yaml`
- View deployments: `kubectl get deployments`

- Other commands: `kubectl get all` -> Display all Kubernetes objects
