# 2.17 - ClusterIP Services

- In general, a fill stack will comprise of groups of pods, hosting different parts of an application, such as:
  - Frontend
  - Backend
  - Key-value store

- Each of these groups of pods need to be able to interact with one another for the application to fully function.

- Each pod will automatically be assigned its own IP address
  - Not static
  - Pods could be removed or added at any given point
  - One cannot therefore rely on these IP addresses for inter-service communication

- Kubernetes ClusterIP services can be used to group the pods together by functionality and provide a single interface to access them.
  - Any requests to that group is assigned randomly to one of the pods within.

- This provides an easy and effective deployment of a microservice-based application on a Kubernetes cluster.

- Each layer or group gets assigned its own IP address and name within the cluster
  - To be used by other pods to access the service.
  - Each layer can scale up or down without impacting service-service communications

- To create, write a definition file:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: ClusterIP
  ports:
  - targetPort: 80
    port: 80
  selector:
    app: myapp
    type: backend
```

- To create the service: `kubectl create -f <service file>.yaml` or `kubectl expose <deployment or pod name> --port=<port> --target-port=<port> --type=clusterIP`

- View services via `kubectl get services`

- From here, the services can be accessed via the ClusterIP or service name.
