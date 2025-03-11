# 8.3 - Persistent Volume Claims

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
