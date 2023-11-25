# 8.4 - Storage Classes

## Static Provisioning

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

## Dynamic Provisioning

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
