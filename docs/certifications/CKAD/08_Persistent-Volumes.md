# 8.0 - Persistent Volumes

## 8.1 - Volumes

- In practice, Docker containers are ran on a "need-to-use" basis.
  - They only exist for a short amount of time / are ephemeral.
  - Once the associated job or process is complete, they're taken down, along with any associated data.

- To persist data associated with a container, one can attach a volume.

- When working in Kubernetes, a similar process can be can be used:
  - Attach a volume to a Pod
  - The volume(s) store data associated with the pod.

### Example Pod-Volume Integration

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
  - image: alpine
    name: alpine
    command: ["/bin/sh", "-c"]
    args: ["shuf -i 0-100 -n  1 >> /opt/number.out"]
    volumeMounts:
    - mountPath: /opt
      name: data-volume
volumes:
- name: data-volume
  hostPath:
    path: /data
    type: Directory
```

- This is ok for a single-node cluster, for multi-node clusters, the data would be persisted to the same directory on each node.
- One would expect them all to be the same and have the same data, but this is not the case as they're different servers.
- To work around this, one can use other storage solutions supported by Kubernetes e.g.:
  - AWS Elastic Block Storage (EBS)
  - Azure Disk
  - Google Persistent Disk

- When using one of these solutions, such as EBS, the volume definition changes:

```yaml
...
volumes:
- name: data-volume
  awsElasticBlockStore:
    volumeID: <volume ID>
      fsType: ext4
```

## 8.2 - Persistent Volumes

- When creating volumes in the prior section, volumes are created in definition file
- When working in a larger environment, where users are deploying lots of pods etc, this can cause issues.
  - Each time a pod is to be deployed, storage needs to be configured.
  - These changes would have to be applied to every pod individually
- To remove this problem and manage the storage centrally, persistent volumes can be leveraged.

### Persistent Volumes

- A cluster-wide pool of storage volumes that is configured by an admin.
- Used by users deploying applications on the cluster.

- Users can select storage from this pool by persistent volume claims.

- Defining a PersistentVolume:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce / ReadOnlyMany / ReadWriteMany # how a volume should be mounted on a host
  capacity:
    storage: 1Gi
  hostPath:
    path: /tmp/data
```

- To create the volume: `kubectl create -f <file>.yaml`

- To view: `kubectl get persistentvolume`

- For production environments, it's recommended to use a storage solution like AWS EBS.
  - Replace `hostPath` with the appropriate attributes in this case.

## 8.3 - Persistent Volume Claims

- Kubernetes objects created by users to request access to a portion of a PersistentVolume.
- Once claims are created, Kubernetes binds the Persistent Volume to the claims
  - Binding determined based on request and properties set on the volume

- **Note:** Each persistent volume claim is bound to a single persistent volume.

- Kubernetes will always try to find a persistent volume with sufficient capacity as requested by the claim.
  - Also considers storage class, access modes, etc.

- If there are multiple possible matches for a claim, and a particular volume is desired, labels and selectors can be utilized.

- It's possible for a smaller claim to be matched to a larger volume if the criteria is satisfied and no other option is available:
  - 1-to-1 relationship between claims and volumes
  - No additional claims could utilize the remaining volume.

- If no other volumes are available, the claim remains in a pending state
  - Automatic assignment occurs when an applicable volume becomes available.

- To create a claim:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessMode:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

- Creation via `kubectl create -f ...`
- To view claims: `kubectl get persistentvolumeclaim`

- When claim is created, Kubernetes will look through all available volumes and bind it appropriately, checking for `accessMode`, `storage` parameters, etc.
  - Associated volume will be noted in a column as part of the `kubectl get` command above.

- To delete a PVC, `kubectl delete persistentvolumeclaim <claim name>`

- One can choose to delete, retain or recycle the volume upon claim deletion
  - Determined via configuring the `persistentVolumeReclaimPolicy` attribute. `Delete` ensures the volume is deleted upon claim deletion.

## 8.4 - Storage Classes

### Static Provisioning

- When working with storage providers such as cloud platforms via Kubernetes, you have to ensure that the resources required are pre-provisioned.
- Using Google Cloud as an example: `gcloud beta compute disks create --size 1Gb --region us-east1 pd-disk`
- The volume can then be referenced in YAML manifests:

```yaml
apiVersion: v1
kind: PersisentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 500Mi
  gcePersistentDisk:
    pdName: pd-disk
    fsType: ext4
```

- This would have to be done every time, a tedious task known as **Static Provisioning**. Thankfully, there's alternatives!

### Dynamic Provisioning

- In an ideal scenario, if we define a `PersistentVolume` manifest referencing a storage provider external to a cluster, the resources required from said provider should be created upon application of the manifest.
- This can be achieved by defining a `StorageClass` for the particular provider. For GCP, an example follows:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/gce-pd
```

- Upon application, the `StorageClass` can be referenced by any `PersistentVolumes` or `PersistentVolumeClaims` by adding the `storageClassName` parameter to the object's spec.
- When these objects are created, Kubernetes will reference the specified Provisioner and automatically provision the desired supporting resources.
- Provisioners exist for most platforms such as `Azure`, `AWS`, `vSphere`. Each will come with their own parameters for further configuration.
- **Note:** Multiple StorageClasses can be defined for the same provisioner with different parameters, so long as they're named differently.

## 8.5 - StatefulSets

### Why StatefulSets?

- Consider a standalone server that is to host a database. Once the database is setup, applications can connect to it.
- To support high-availability, the process is repeated on other servers, however the new databases are blank.
- In an ideal scenario, one would want the data stored to be replicated across all instances - how is this achieved?
- In a standard scenario, native replication features supported by the database would be utilised. This can be done in multiple scenarios:

#### Master-Worker Topology

- Master node is set up and is the only node that supports write operations
- Worker node is setup, and the master's data is cloned to the replica.
- Continuous replication is enabled between master and worker.

- This is fine, but as it scales up, more and more resources are required from the master - this is not sustainable.
- Each worker receives the data from the 1 master node, they have no knowledge of the other workers.

#### Kubernetes Setup

- With deployments, the order of pod deployment cannot be guaranteed as pods all come up at the same time, so one could not set something up for worker 1 to come up before worker 2.
- Another way is required to differentiate master vs worker. The master requires a static hostname / identifier.
- Statefulsets aim to support this workflow / architecture.
- Similar to deployments, they create pods based on a template and are scalable, but pods are created in a sequential order. Pod 1 must be running before Pod 2 kicks off, etc.
- StatefulSets assign a unique name to each pod, based on the name of the StatefulSet and a numeric index starting from 0. E.g. `redis-0`, `redis-1`, ...
- Each of the "worker" pods can be configured to point to the specific parameters associated with the master pod.

### Introduction

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

### Headless Services

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

### Storage in StatefulSets

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
