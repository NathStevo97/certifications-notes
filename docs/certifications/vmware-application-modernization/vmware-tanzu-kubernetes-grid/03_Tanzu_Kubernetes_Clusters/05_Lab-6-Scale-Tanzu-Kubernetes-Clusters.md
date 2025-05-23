# 3.5 - Lab 6

## Objectives and Tasks

- Examine the Tanzu Kubernetes Cluster
- Scale the Tanzu Kubernetes Cluster

## Examine the Tanzu Kubernetes Cluster

1. Using the terminal, retrieve the admin kubeconfig file for the workload cluster.

    `tanzu cluster kubeconfig get tkc-01 --admin`

2. List the kubectl contexts.

    `kubectl config get-contexts`

3. Set the kubectl context to point to the workload cluster.

    `kubectl config use-context tkc-01-admin@tkc-01`

4. Display all pods running on the cluster.

    `kubectl get pods -A`

    The status of some `pinniped-post-deploy-job` pods might display as error, which is expected.

5. Display the Tanzu Kubernetes cluster nodes.

    `kubectl get nodes`

    The output displays the following two nodes.

6. In the vSphere Client, click **Menu**.
7. Click **Hosts and Clusters**.
8. Review the VM names in the `rp-tkg-production` resource pool.

    The VM names correspond to the node names in the `kubectl get nodes` output.

## Scale the Cluster

1. Using the terminal, get the Tanzu Kubernetes cluster information.

    `tanzu cluster list`

    The output shows `WORKERS 1/1`.

2. Scale the worker nodes to 2.

    `tanzu cluster scale tkc-01 -w 2`

    The scale operation performs in the background.

3. Verify the status of the scale operation.

    `tanzu cluster list`

    The output displays `STATUS updating` and `WORKERS 1/2`.

4. Set the kubectl context to point to the management cluster.

    `kubectl config use-context sa-compute-01-mgmt-admin@sa-compute-01-mgmt`

5. Monitor the cluster API resources.
    1. Get the VM status.

        `watch kubectl get machines`

    2. Wait for the new VM phase to go from Provisioning to Running before continuing.
    3. Press Ctrl+C to exit the `watch` command.
6. Verify the status of the scale operation again.

    `tanzu cluster list`

    The output displays `STATUS running` and `WORKERS 2/2`.

    Provisioning can take up to 10 minutes to complete.
