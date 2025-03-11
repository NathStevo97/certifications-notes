# 8.5 - StatefulSets

## Why StatefulSets?

- Consider a standalone server that is to host a database. Once the database is setup, applications can connect to it.
- To support high-availability, the process is repeated on other servers, however the new databases are blank.
- In an ideal scenario, one would want the data stored to be replicated across all instances - how is this achieved?
- In a standard scenario, native replication features supported by the database would be utilised. This can be done in multiple scenarios:

### Master-Worker Topology

- Master node is set up and is the only node that supports write operations
- Worker node is setup, and the master's data is cloned to the replica.
- Continuous replication is enabled between master and worker.

- This is fine, but as it scales up, more and more resources are required from the master - this is not sustainable.
- Each worker receives the data from the 1 master node, they have no knowledge of the other workers.

### Kubernetes Setup

- With deployments, the order of pod deployment cannot be guaranteed as pods all come up at the same time, so one could not set something up for worker 1 to come up before worker 2.
- Another way is required to differentiate master vs worker. The master requires a static hostname / identifier.
- Statefulsets aim to support this workflow / architecture.
- Similar to deployments, they create pods based on a template and are scalable, but pods are created in a sequential order. Pod 1 must be running before Pod 2 kicks off, etc.
- StatefulSets assign a unique name to each pod, based on the name of the StatefulSet and a numeric index starting from 0. E.g. `redis-0`, `redis-1`, ...
- Each of the "worker" pods can be configured to point to the specific parameters associated with the master pod.

## Introduction

- StatefulSets aren't always required, it really depends on the application.
- As discussed previously, this may depend on situations such as:
  - Instances need to come up in a particular order
  - Instances need to have specific names

- StatefulSets can be created effectively in the same manner as a Deployment, with the value of `kind:` being replaced accordingly, and the name of the headless service to be associated with the statefulset to be added against the `serviceName` parameter.
- An example for Redis follows:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster
spec:
  serviceName: redis-cluster
  replicas: 6
  selector:
    matchLabels:
      app: redis-cluster
  template:
    metadata:
      labels:
        app: redis-cluster
    spec:
      containers:
      - name: redis
        image: redis:5.0.1-alpine
        ports:
        - containerPort: 6379
          name: client
        - containerPort: 16379
          name: gossip
        command: ["/conf/update-node.sh", "redis-server", "/conf/redis.conf"]
        env:
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        volumeMounts:
        - name: conf
          mountPath: /conf
          readOnly: false
        - name: data
          mountPath: /data
          readOnly: false
      volumes:
      - name: conf
        configMap:
          name: redis-cluster
          defaultMode: 0755
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

- Upon creation, each pod is created sequentially and gets a unique DNS record.
- This is ordered, graceful deployment and scaling.
- The same behaviour follows during deletion.
- The behaviour can be overwritten by setting the `podManagement` parameter in the `spec` to `Parallel`, such that the pods are not created sequentially.

## Headless Services

- Each pod in a StatefulSet is deployed, unless specified otherwise, in a sequential manner and has a unique name for identification.
- In the case of Kubernetes, to allow interaction with these pods and inter-pod communication, a Service is required.
- In a standard deployment, one could deploy a load balancer service to distribute traffic across the master and the workers.
- In StatefulSets, this doesn't work 100%, as only write actions should be allowed to the master node. How is this achieved?

- The master node can be reached directly via its IP address, and the workers via their DNS (determined via IP addresses) - these cannot be used as the IP addresses are always subject to change.
- What is needed, is a service that does not load balance requests, but gives a DNS entry to reach each pod - this is achieved by a `Headless` service.
- Headless services are created like standard services, but do not have their own IPs like ClusterIPs or balance loads, it simply creates DNS entries for each pod via the pod name and a subdomain.
- The DNS record is of the form `<pod name>.<headless service name>.<namespace>.svc.<cluster-domain>.example`
- Headless services can be created via a standard YAML definition file for services, but setting `clusterIP: None`

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-service
spec:
  ports:
    - port: 6379
      name: client
      targetPort: 6379
    - port: 16379
      name: gossip
      targetPort: 16379
  selector:
    app: redis-cluster
  clusterIP: None
```

- For pod DNS entries to be created, two optional fields must be added to the pod definition files:
  - `subdomain:` - The name of the headless service
  - `hostname:` - The name to be assigned in the DNS record for the given pod.

- By default, if these aren't set, the headless service will not create a DNS record for the pods in a deployment.
- In standard deployments, this still wouldn't work as all pods would have the same hostname if these parameters are added, StatefulSets work around this by previously defined features and including `serviceName` in the spec.

## Storage in StatefulSets

- With StatefulSets, if a PVC and storage is already created, all pods in the StatefulSet will try to use the same PVC.
- This may not always be desired, for example, in the MySQL scenario, each instance should have its own storage media, but the same data - each pod therefore needs its own PVC and PV.
- This is achieved using a `PersistentVolumeClaim` template in the `StatefulSet`'s specification. An example for Redis follows:

```yaml
...
template:
    metadata:
      labels:
        app: redis-cluster
    spec:
      containers:
      - name: redis
        image: redis:5.0.1-alpine
        ports:
        - containerPort: 6379
          name: client
        - containerPort: 16379
          name: gossip
        volumeMounts:
        - name: conf
          mountPath: /conf
          readOnly: false
        - name: data
          mountPath: /data
          readOnly: false
      volumes:
      - name: conf
        configMap:
          name: redis-cluster
          defaultMode: 0755
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

- These claim templates can refer to any given Storage Class created, so for each pvc created per replica, the associated resources are created e.g. PVC, PV, etc.
- In the event of failure for these pods,the PVCs and associated resources are not deleted automatically, once the pod is back online, the same storage objects are re-attached, ensuring stateful data.
