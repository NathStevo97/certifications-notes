# 3.3 - Lab 5

Tags: Done

## Create a Tanzu Kubernetes Cluster Configuration File

1. Using the terminal, navigate to the `clusterconfigs` directory.

    `cd ~/.tanzu/tkg/clusterconfigs`

2. Copy the management cluster configuration as a template for the workload cluster.

    `cp sa-compute-01-mgmt.yaml tkc-01.yaml`

3. Update the configuration file for the workload cluster.
    1. Open `tkc-01.yaml` in Visual Studio Code.

        `code tkc-01.yaml`

    2. Modify the following parameters.
    3. Add the following parameter.
    4. Save the file and close Visual Studio Code.
4. Verify that the configuration file matches the reference configuration file.

    `checkconfig tkc-01.yaml`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.
5. Run the `tanzu cluster create` command with the `-dry-run` option which queries vCenter Server to ensure that the vSphere resources exist.

    `tanzu cluster create -f tkc-01.yaml --dry-run`

    1. If the output displays `exit status 1`, review the configuration parameters from step 3.

## Create a Tanzu Kubernetes Cluster

1. Using the terminal, navigate to the `clusterconfigs` directory.

    `cd ~/.tanzu/tkg/clusterconfigs`

2. Set the environment variables to install from the local Harbor registry.

    `source ~/Workspace/harbor-vars.sh`

3. Create the cluster by using the configuration file that was created in the previous task.

    `tanzu cluster create -f tkc-01.yaml`

    Wait for `Workload cluster 'tkc-01' created` to display before continuing.

    The Tanzu Kubernetes cluster takes approximately 20 minutes to deploy.

4. List the Tanzu Kubernetes clusters.

    `tanzu cluster list`
