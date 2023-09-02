# 2.3 - ETCD In Kubernetes

- The etcd data store stores information relating to the cluster, such as:
  - Nodes
  - Pods
  - Configs
  - Secrets
  - Roles
- Every piece of information obtained from a kubectl get command is obtained from the etcd server.
- Additionally, any changes made to the cluster, such as adding nodes, deploying
pods or updating resources, the same changes are updated in the etcd server.
- Changes cannot be confirmed until the etcd server has been updated.
- The manner in which etcd is deployed is heavily dependent on your cluster setup. For the purposes of this course, 2 cases will be considered:
  - A cluster built from scratch
  - A cluster deployed using kubeadm
- Setting the cluster up from scratch requires manual downloading and installing the binaries; then configuring ETCD as a service in the master node.
- There are many options that can be added to this service, most of them relate to certificates, the rest describe configuring etcd as a cluster.
- One of the primary options to consider is the flag: `--advertise-client-urls https://${INTERNAL_IP}:2379`
- This defines the address which the ETCD service listens on, by default it's port 2379 on the IP of the server
  - It is in fact this URL that should be configured on the kube-api server when it attempts communication with the etcd server.
- If creating a cluster using kubeadm, the ETCD server is deployed as a pod in the kube-system namespace.
  - The database can then be explored using the etcdctl command within the pod, such as the following; which lists all the keys stored by kubernetes.

  ```shell
  kubectl exec etcd-mater -n kube-system etcdctl get / --prefix-keys-only
  ```

- The data stored on the etcd server adheres to a particular structure. The root is a registry containing various kubernetes resources e.g. pods, replicasets.
- In high-availability (HA) environments, multiple master nodes will be present, each containing their own ETCD instance.
  - In this sort of scenario, each instance must be made aware of another, which can be configured by adding the following flag in the etcd service file:

  ```shell
  --initial-cluster controller-0=https://${CONTROLLER0_IP}:2380, controller-1=https://${CONTROLLER1_IP}:2380, ...,
  controller-N=https://${CONTROLLERN_IP}:2380
  ```

