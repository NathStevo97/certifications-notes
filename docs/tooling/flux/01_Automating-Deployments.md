# 1.0 - Understanding the Challenges of Automating Deployments

- [1.0 - Understanding the Challenges of Automating Deployments](#10---understanding-the-challenges-of-automating-deployments)
  - [Introduction](#introduction)
  - [1.1 - Declarative Configuration with Kubernetes](#11---declarative-configuration-with-kubernetes)
  - [1.2 - Cloud Native Workflows](#12---cloud-native-workflows)
  - [1.3 - Managing the Integrity of Configuration](#13---managing-the-integrity-of-configuration)

## Introduction

- When transitioning to cloud native approaches and automated deployments, common reliability issues can occur such as:
  - Failed deployments
  - Environment-level ambiguity
- These issues can lead to longer release cycles - GitOps aims to improve delivery and minimize the occurrences of these issues.

## 1.1 - Declarative Configuration with Kubernetes

- Kubernetes = defacto Container Orchestration tool
- Supports operations including:
  - Rollout and rollback of workloads
  - Workload-to-workload discovery
  - Automated restarting (attempted) restarting of workloads upon failure
  - Automatic scaling of workloads to meet demands.

- Kubernetes leverages controllers and operates to observe the current state of the cluster, and the desired state, typically defined by YAML configuration, and automatically makes the changes to match the two.
- Yaml Configuration is typically applied via the `kubectl apply -f <filename>.yaml` commands.
  - Cloud native workflows also help achieve this.

## 1.2 - Cloud Native Workflows

- These are automated workflows or pipelines designed to increase the speed, frequency and quality of application service deployments.
- Typically defined as Continuous Integration and Continuous Deployment
  - Continuous Integration:
    - Commits from developers trigger automated builds and tests -> packaging the code into an artifact registry
  - Continuous Deployment:
    - When the CI package is deemed "release-ready" - a package can be automatically rolled out and deployed.

## 1.3 - Managing the Integrity of Configuration

- Container images consist of application code and any dependencies it may have.
- Containers are immutable by nature - if any updates are needed, a new version of the container image is required, and must be built separately.
- The versioned artifacts are then stored in a registry like Docker Hub or JFrog Artifactory

- **Workload Configuration:**
  - Config manifests are typically used to define the workload, these tend to include:
    - Image reference: Defining the desired version of the container image
    - Attributes: Key-value pairs defined in the YAML spec
  - The configs can be altered post-deployment using imperative commands (commands that don't require any changes to YAML manifests)

- When imperative commands are used, the configuration begins to **drift** -> it no longer reflects the expected changes defined in the YAML configurations, etc.
