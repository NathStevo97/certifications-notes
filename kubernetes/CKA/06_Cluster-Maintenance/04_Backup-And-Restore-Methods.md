# 6.4 - Backup and Restore Methods

- It's good practice to save resource configuration definition files
- Kube-api server can be used to query all resources to get yaml files for each
- E.g. `kubectl get all --all-namespaces -o yaml > filename.yaml`
- The etcd cluster stores information about the state of the cluster e.g. what nodes
are on it and what applications are they running
- When configuring the etcd, you can configure the data directory for the etcd data
store via the `--data-dir` flag
- You can take a snapshot of the etcd database using the etcdctl utility
- To restore the cluster from the backup:
  - Service kube-apiserver stop
  - `etcdctl snapshot restore snapshot.db --options`
  - New data store directory created
  - The etcd service file must then be reconfigured for the new cluster token and data directory
  - Reload the daemon and restart the service
- Backup candidates:
  - Kube-API Server query - Generally the more common method
  - ETCD Server

## Disaster Recovery with ETCD in Kubernetes:

Assuming ETCDCTL is installed, use it to take a snapshot, make sure to specify the flags,
which can all be found via examining the etcd pod and ARE MANDATORY for
authentication:

```shell
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save PATH/TO/BACKUP/BACKUP.db
```

- Suppose disaster happens:
- Restore the snapshot to a new folder:

```shell
ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd-from-backup \
snapshot restore PATH/TO/BACKUP/BACKUP.db
```

- Update the etcd pod's volume hostpath and mount paths for etcd-data to be
`/var/lib/etcd-from-backup` etc as appropriate by updating the yaml file at
`/etc/kubernetes/manifests/etcd.yaml`
- The etcd pod should automatically restart once this update is done, bringing back the pods
stored in the backup along with it. (Use `watch "docker ps | grep etcd"` to track)

## Working with ETCDCTL

- For backup and restore purposes, make sure to set the ETCDCTL API to 3: `export
ETCDCTL_API=3`
- For taking a snapshot of the etcd cluster: etcdctl snapshot save -h and keep a note
of the mandatory global options.
- For a TLS-Enabled ETCD Database, the following are mandatory:
  - `--cacert`
  - `--cert`
  - `--endpoints[IP:PORT]`
  - `--key`
- Use the snapshot restore option for backup: `etcdctl snapshot restore -h`
  - Note options available and apply as appropriate

