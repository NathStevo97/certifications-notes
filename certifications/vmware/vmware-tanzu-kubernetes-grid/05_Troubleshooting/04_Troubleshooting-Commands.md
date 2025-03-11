# 5.4 - Troubleshooting Commands

- [5.4 - Troubleshooting Commands](#54---troubleshooting-commands)
  - [Objectives](#objectives)
  - [Connecting to Cluster Nodes with SSH](#connecting-to-cluster-nodes-with-ssh)
  - [Failure of Management Cluster Create Command](#failure-of-management-cluster-create-command)
  - [Recovering Cluster Credentials](#recovering-cluster-credentials)

## Objectives

- Describe how to use SSH to connect to a Tanzu Kubernetes VM
- Detail the steps to troubleshoot a failed cluster deployment

## Connecting to Cluster Nodes with SSH

- SSH can be used  connect to individual nodes in both management and Tanzu Kubernetes clusters
- For this to happen, you need an SSH key pair - one should already exist following deployment of the management cluster
- The SSH key entered in the installer for the management cluster is associated with the CAPV user account
  - `ssh capv@<VM IP Address>`
  - Assume root privileges with `sudo -i`
- As the SSH key is present on the system running the SSH command, no password will eb required

## Failure of Management Cluster Create Command

- Sometimes a cluster fails to create - a typical error is `waiting for cert-manager to be available`
- Following steps can be used:
  - Verify node status `kubectl get nodes`
  - Verify pod status `kubectl get pods -A`
  - For any failing pods, check the logs and events:
    - `kubectl describe pod -n <namespace> <pod name>`
    - `kubectl logs -n <namespace> <pod name>`
  - Resolve issues with configuration or connectivity based on output
  - Delete the management cluster - `tanzu management-cluster delete`
  - Run the create command again to ensure a clean deployment: `tanzu management-cluster create`

## Recovering Cluster Credentials

- Run `tanzu management-cluster create` - recreates the `.kube-tkg/config` file
- Obtain the IP address of the management cluster control plane node from vSphere
- Use SSH to login to the management cluster control plane node: `ssh capv@<node IP address>`
- Access the `admin.conf` file in the management cluster - `sudo cat /etc/kubernetes/admin.conf`
- Copy the following into the local `.kube-tkg/config` file:
  - Cluster name
  - Cluster user name
  - Cluster context
  - Client certificate data
