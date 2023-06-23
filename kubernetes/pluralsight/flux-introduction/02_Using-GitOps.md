# 2.0 - Using the GitOps Approach for Automating Deployments

## 2.1 - GitOps Principles

## 2.2 - GitOps in the WIld

## 2.3 - Introducing Flux

- Flux is implemented as a set of Kibernetes controllers that implement the GitOps principles as defined by the GitOps project
- It handles configurations provided by YAML, Kustomize Overlays, or Helm charts to achieve the desired state.
- Offers optional support for monitoring repositories in single container registries for new application images
- Can be used with other tools to support automated progressive deployments e.g. canary releases or blue/green deployments.

### Note

- Flux v2 is predated by an earlier, much different solution for GitOps, titled Flux v1.

- The different controllers that comprise the Flux solution, are also collectively known as the GitOps toolkit

### Toolkit Components

- **Source Controller:** Responsible for fetching the desired state from a suitable source e.g. Git repository, S3 Bucket, etc.
  - It will periodically check the source for any changes to the desired state.
- **Kustomize Controller:** Reconciles the differences between the current and desired state.
  - Generates and validates manifests before application (if configuration is defined in Kustomize overlays)
- **Helm Controller:** Similar to the Kustomize controller, but focuses on using Helm charts for deployment
- **Notification Controller:** Receives events from systems outside the cluster and allows the events to be processed by other members of the GitOps toolkit.
  - Can also send out alerts from other GitOps toolkits to external tools e.g. deployment success/failures to Slack
- **Image Reflector Controller:** Monitors specific container repositories and reflects the tags used within the cluster.
- **Image Automation Controller:** Writes the latest available tag to the manifest, which is committed and pushed to source.

### Flux CLI

- A fully-featured CLI utility for working with the GitOps toolkit and for managing GitOps workflows.
- Supports:
  - Provisioning - Enables flux to be bootstrapped to an existing cluster
  - Management - Allows for ongoing management of a Flux deployment
  - Querying - Provides a means for retrieving status information.

## 2.4 - Installing Flux

- Flux can be installed via either:
  - Flux CLI
  - Flux Helm Chart
  - Flux Kubernetes Manifests

- Installing via the Flux CLI is advised as it:
  - Allows bootstrapping of the GitOps toolkit
  - Establishing the 'Single Source of Truth'

- **Note:** Instructions were done on a K3D Cluster.

- Install the Flux CLI via the following [link](https://fluxcd.io/flux/cmd/).
- Bootstrap and install subcommands offered, the bootstrap will in addition to the installation, create a remote repository to store the toolkit component configuration
  - Allows Flux to effectively manage itself according to GitOps principles.

- Check the env meets the prerequisites: `flux check --pre`
- A Github PAT token is needed for the bootstrap repo - it needs to be used as a private repo.
- Set via `export GITHUB_TOKEN="$(cat /path/to/file)"`
- Run: `flux bootstrap github --repository <repository name> --owner <github username> --personal true --components-extra=image-reflector, image-automation-controller`

- 