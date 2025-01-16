# 6.0 - Cluster Maintenance

- [6.0 - Cluster Maintenance](#60---cluster-maintenance)
  - [6.1 - OS Upgrades](#61---os-upgrades)
  - [6.2 - Kubernetes Software Versions](#62---kubernetes-software-versions)
  - [6.3 - Cluster Upgrade Process](#63---cluster-upgrade-process)
  - [6.4 - Backup and Restore Methods](#64---backup-and-restore-methods)
    - [Disaster Recovery with ETCD in Kubernetes](#disaster-recovery-with-etcd-in-kubernetes)
    - [Working with ETCDCTL](#working-with-etcdctl)

## 6.1 - OS Upgrades

- Suppose you have a cluster with a few nodes and pods serving applications; what
happens if one of these nodes goes down?
  - Associated pods are rendered inaccessible
  - Depending on the deployment method of these PODs, users may be
impacted
- If multiple replicas of the pod are spread across the cluster, users are uninterrupted
as it's still accessible
  - Any pods running ONLY on that node however will experience downtime
- Kubernetes will automatically try and restart the node
  - If it comes back on immediately, kubectl restarts and the pods restart
  - If after 5 mins and it's not back online, Kubernetes considers the pods as
dead and terminates them from the node
    - If part of a replicaset, the pods will be recreated on other nodes
- The time it takes for a pod to come back online is the pod eviction timeout
  - Can be set on the controller manager via: `kube-controller-manager --pod-eviction-timeout=xmys`
    - X,y = integer values
- If the node comes back online after the timeout it restarts as a blank node, any pods
that were on it and not part of a replicaset will remain "gone"
- Therefore, if maintenance is required on a node that is likely to come back within 5
minutes, and workloads on it are also available on other nodes, it's fine for it to be
temporarily taken down for upgrades
  - There is no guarantee that it'll reboot within the 5 minutes
- Nodes can be "drained", a process where they are gracefully terminated and
deployed on other nodes
  - Done so via: `kubectl drain <node name>`
  - Node cordoned and made unschedulable
- To uncordon node: `kubectl uncordon <nodename>`
- To mark the node as unschedulable, run: `kubectl cordon <nodename>`
  - Doesn't terminate any preexisting pods, just stops any more from being
scheduled
- Note: May need the flag `--ignore-daemonsets` and or `--force`

## 6.2 - Kubernetes Software Versions

- When installing a kubernetes cluster, a specific version of kubernetes is installed
alongside
- Can be viewed via `kubectl get nodes` in the version column
- Release versions follow the process major.minor.patch
- Kubernetes is regularly updated with new minor versions every couple of months
- Alpha and beta versions also available
- Alpha - Features disabled by default, likely to be buggy
- Beta - Code tested, new features enabled by default
- Stable release - Code tested, bugs fixed
- Kubernetes releases found in a tarball file in Github; contains all required
executables of the same version
- **Note:** Some components within the control plane will not have the same version
numbers and are released as separate files; ETCD cluster and CoreDNS servers
being the main examples

## 6.3 - Cluster Upgrade Process

- The kubernetes components don't all have to be at the same versions
  - No component should be at a version higher than the kube-api server
  - If Kube-API Server is version X (a minor release), then the following ranges
apply for the other components for support level:
    - Controller manager: X-1
    - Kube-Scheduler: X-1
    - Kubelet: X-2
    - Kube-Proxy: X-2
    - Kubectl: X-1 - X+1
- At any point, Kubernetes only supports the 3 most recent minor releases e.g. 1.19 - 1.17
- It's better to upgrade iteratively over minor processes e.g. 1.17 - 1.18 and so on
- Upgrade process = Cluster-Dependent
- If on a cloud provider, built-in functionality available
- If on kubeadm/manually created cluster, must use commands:
  - `kubeadm upgrade plan`
  - `kubeadm upgrade apply`
- Cluster upgrades involve two steps:
  - Upgrade the master node
    - All management components go down temporarily during the processes
    - Doesn't impact the current node workloads (only if you try to do anything with them)
  - Upgrade the worker nodes
    - Can be done all at once - Results in downtime
    - Can be done iteratively - Minimal downtime by draining nodes as they
get upgraded one after another
    - Could also add new nodes with the most recent software versions
- Proves especially inconvenient when on a cloud provider
- Upgrading via Kubeadm:
  - `kubeadm upgrade plan`
    - Lists latest versions available
    - Components that must be upgraded manually
    - Command to upgrade kubeadm
  - Note: kubeadm itself must be upgraded first: `apt-get upgrade -y kubeadm=major.minor-patch_min-patch_max`
- Check upgrade success based on CLI output and kubectl get nodes
- If Kubelet is running on Master node, this must be upgraded next the master node
and restart the service:
  - `apt-get upgrade -y kubelet=1.12.0-00`
  - `systemctl restart kubelet`
- Upgrading the worker nodes:
  - Use the drain command to stop and transfer the current workloads to other
nodes, then upgrade the following for each node (ssh into each one):
    - Kubeadm
    - Kubelet
    - Node config: `kubeadm upgrade node config --kubelet-version major.minor.patch`
  - Restart the service: `systemctl restart kubelet`
- Make sure to uncordon each node after each upgrade!

## 6.4 - Backup and Restore Methods

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

### Disaster Recovery with ETCD in Kubernetes

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

### Working with ETCDCTL

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
