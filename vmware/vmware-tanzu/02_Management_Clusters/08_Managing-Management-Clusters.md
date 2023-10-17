# 2.8 - Managing Management Clusters

Tags: Done

# Learner Objectives

- Describe the commands available for working with management clusters.

# Working with Multiple Management Clusters

| Command | Description |
| --- | --- |
| tanzu login | Displays list of management clusters deployed and enables changes to the .kube-tkg/config context to change the context |
| tanzu-management-cluster get | Display data of a particular  management cluster |

# Adding Existing Management Clusters to Tanzu CLI

1. Run `tanzu login`
2. Select `new server`
3. Select `server endpoint` → Provide the login URL of the vSphere with Tanzu supervisor cluster
4. If not 3. select local kubeconfig and provide kubeconfig file of the other management cluster.

- In one command, this could be achieved via: `tanzu login --kubeconfig <kube config path> --context <context name> --name <management cluster name>`
