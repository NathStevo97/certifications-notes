# 8.0 - Storage

For the following topics, please refer to the linked section of the CKAD course:

- Volumes (CKAD 8.1)
- Persistent Volumes (CKAD 8.2)
- Persistent Volume Claims (CKAD 8.3)

## 8.1 - Storage in Docker

- For storage in Docker, must consider both Storage and Volume Drivers.
- Docker file system setup at /var/lib/docker
  - Contains data relating to containers, images, volumes, etc.
- To ensure data in a container is stored, create a persistent volume:
  - `Docker volume create <volume>`
  - The volume can then be mounted into a container: `docker run -v data_volume:/path/to/volume <container>`
  - **Note:** if a volume hasn't been already created before this run command, docker will automatically create a volume of that name at the path specified
- For mounting a particular folder to a container, replace <data_volume> or whatever named with the full path to the folder you want to mount
- Alternative command: `--mount type=<type>,source=<source>,target=<container volume path> container`
- Operations like this, maintaining a layered architecture etc. is handled by storage
drivers such as AUFS, BTRFS, Overlay2, Device Mapper
- Docker chooses the best storage driver given the OS and application

## 8.2 - Volume Driver Plugins in Docker

- Default volume driver plugin = local
- Alternatives available include:
  - Azure File Storage
  - GCE-Docker
  - VMware vSphere Storage
  - Convoy
- To specify the volume driver, append `--volume-driver <drivername>` to the `docker run` command

## 8.3 - Container Storage Interface (CSI)

- CRI = Container Runtime Interface
  - Configures how Kubernetes interacts with container runtimes, such as
Docker
- CNI - Container Network Interface
  - Sets predefined standards for networking solutions to work with Kubernetes
- CSI - Container Storage Interface
  - Sets standards for storage drivers to be able to work with kubernetes
  - Examples include Amazon EBS, Portworx
- All of the above allow any container orchestration to work with drivers available

## 8.4 - Volumes

- In practice, Docker containers are ran on a "need-to-use" basis.
  - They only exist for a short amount of time
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

## 8.5 - PersistentVolumes

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
    - ReadWriteOnce / ReadOnlyMany / ReadWriteMany
  capacity:
    storage: 1Gi
  hostPath:
    path: /tmp/data
```

- To create the volume: `kubectl create -f <file>.yaml`

- To view: `kubectl get persistentvolume`

- For production environments, it's recommended to use a storage solution like AWS EBS.
  - Replace `hostPath` with the appropriate attributes in this case.

## 8.6 - PersistentVolumeClaims

- Kubernetes objects created by users to request access to a portion of a PersistentVolume.
- Once claims are created, Kubernetes binds the Persistent Volume to the claims
  - Binding determined based on request and properties set on the volume

- **Note:** Each persistent volume claim is bound to a single persistent vilume

- Kubernetes will always try to find a persistent volume with sufficient capacity as requested by the claim.
  - Also considers storage class, access modes, etc.

- If there are multiple possible matches for a claim, and a particular volume is desired, labels and selectors can be utilised.

- It's possible for a smaller claim to be matched to a larger volume if the criteria is satisfied and no other option is available:
  - 1-to-1 relationship between claims and volumes
  - No additional claims could utilise the remaining volume.

- If no opther volumes are available, the claim remains in a pending state
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

- When claim is created, Kubernetes will look through all available volumes and binds appropriately
  - Associated volume will be noted in a column as part of the `kubectl get` command above.

- To delete a PVC, `kubectl delete persistentvolumeclaim <claim name>`

- One can choose to delete, retain or recycle the volume upon claim deletion
  - Determined via configuring the `persistentVolumeReclaimPolicy` attribute

## 8.7 - Storage Class

- Allows definition of a provisioner, so that storage can automatically be provisioned
and attached to pods when a claim is made
- Make storage classes using yaml files to define a particular storage class
- To use the storage class, specify it in the pvc definition file
- Still creates a PV, BUT doesn't require a definition file
- Provisioners available include:
  - AWS
  - GCP
  - Azure
  - ScaleIO
- Additional configuration options available for different provisioners, so you could
have multiple storage classes per provisioners
