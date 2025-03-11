# 8.2 - Persistent Volumes

- When creating volumes in the prior section, volumes are created in definition file
- When working in a larger environment, where users are deploying lots of pods etc, this can cause issues.
  - Each time a pod is to be deployed, storage needs to be configured.
  - These changes would have to be applied to every pod individually
- To remove this problem and manage the storage centrally, persistent volumes can be leveraged.

## Persistent Volumes

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
