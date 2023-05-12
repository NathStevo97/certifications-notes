# 8.1 - Volumes

- In practice, Docker containers are ran on a "need-to-use" basis.
  - They only exist for a short amount of time
  - Once the associated job or process is complete, they're taken down, along with any associated data.

- To persist data associated with a container, one can attach a volume.

- When working in Kubernetes, a similar process can be can be used:
  - Attach a volume to a Pod
  - The volume(s) store data associated with the pod.

## Example Pod-Volume Integration

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
