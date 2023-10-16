# 3.2 - Deploying Tanzu Kubernetes Cluster

Tags: Done

# Learner Objectives

- Describe the options for deploying Tanzu Kubernetes clusters
- Describe how Tanzu Kubernetes clusters are created

# Tanzu CLI Cluster Plugin

- The Tanzu CLI core executable must be installed as well as the CLI plugins associated with Tanzu Kubernetes cluster management and feature operations
- Once installed, the following commands are available to be appended to `tanzu cluster`

![Untitled](3%202%20-%20Deploying%20Tanzu%20Kubernetes%20Cluster%2036c9fe9912c245d1af3202f7b26614cc/Untitled.png)

## Tanzu Cluster Create

The following  flags can be added to the `tanzu cluster create` command:

![Untitled](3%202%20-%20Deploying%20Tanzu%20Kubernetes%20Cluster%2036c9fe9912c245d1af3202f7b26614cc/Untitled%201.png)

# Creating Tanzu Kubernetes Clusters

- When running `tanzu cluster create -f <file.yaml>`, the Tanzu CLI communicates with the Cluster API in the management cluster, which then uses the Cloud Infrastructure provider e.g. vSphere CAPV to deploy the Tanzu Kubernetes Cluster(s) required.
  - This will use the configuration and deployment plans outlined e.g. deploy x control plane nodes, y  Worker nodes.
- Once deployed, the cluster API will continuously compare the configuration in the Tanzu Kubernetes Cluster to manage and facilitate various operations.

![Untitled](3%202%20-%20Deploying%20Tanzu%20Kubernetes%20Cluster%2036c9fe9912c245d1af3202f7b26614cc/Untitled%202.png)

# Cluster Configuration Files

- These files contain the configuration parameters passed to the Tanzu CLI, and combined with cluster plan template files to deploy Tanzu Kubernetes Cluster(s)
- Example parameters include (for a vSphere deployment)

![Untitled](3%202%20-%20Deploying%20Tanzu%20Kubernetes%20Cluster%2036c9fe9912c245d1af3202f7b26614cc/Untitled%203.png)

# Deploying Clusters with a High Availability Control Plane

- The `CLUSTER_PLAN` parameter determines the number of control plane nodes:
  - `dev` sets 1 control plane node
  - `prod` deploys 3 control plane nodes and 3 worker nodes.

# Previewing the YAML File for Tanzu Kubernetes Clusters

- Deployments can be tested based on the YAML file by appending the `--dry-run` flag
- This is especially useful if making changes in the providers file.

# Overriding Default Configuration Parameters

- The Tanzu CLI `management-cluster` and `cluster` commands will take any configuration parameters specified in the file pointed at by the `-f` or `--file` flags
- These parameters can be overridden by defining them as environment variables before using the CLI command e.g.
`export <var≥"new value"`

# Deploying Clusters that Run a Specific Kubernetes Version

- Each release of Tanzu Kubernetes Grid:
  - provides a default Kubernetes version
  - Supports a defined set of Kubernetes versions
- Example command to deploy with a specific version:
`tanzu cluster create -f <cluster yaml> --tkr v1.19.9---vmware.2-tkg.1`
