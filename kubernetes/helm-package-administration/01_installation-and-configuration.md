# 1.0 - Helm Installation and Configuration

- [1.0 - Helm Installation and Configuration](#10---helm-installation-and-configuration)
  - [1.1 - Helm Overview](#11---helm-overview)
    - [Charts](#charts)
  - [1.2 - Environment Setup](#12---environment-setup)
  - [1.3 - Installation](#13---installation)
  - [1.4 - Configuration](#14---configuration)
  - [1.5 - Configuration Demo](#15---configuration-demo)

## 1.1 - Helm Overview

- Helm: A package manager for Kubernetes.
- Used to define Kubernetes applications in charts.
- Using charts and Helm, one can:
  - Manage complexity
  - Easily update and rollback
  - Share Charts

- Helm v3 includes a number of changes:
  - Tiller removed, one would have to run helm init.
  - Helm search supports local repositories and against helm hub
  - Command overhaul, `helm init` is no longer required for example
  - Releases are scoped to namespaces
  - Chart API and Dependency Managers have been updated.

- Tiller was a server-side component with helm to help deployment. This meant it had extensive advanced permissions, which posed a huge security risk; its removal mitigates this risk.

### Charts

- Charts are a collection of YAML files that would be typically used to deploy Kubernetes resources.
- By wrapping the desired YAML files e.g. those associated with an application, management and deployment is made significantly easier.

---

## 1.2 - Environment Setup

- Tools required:
  - VS Code
  - Docker
  - Kubernetes (can also use minikube, k3d, etc.)

---

## 1.3 - Installation

- Ensire all prerequisites are installed.
- Installation via any desired method:
  - From binary
  - Script Install
  - Package Managers (apt, chocolatey, homebrew, etc.)

---

## 1.4 - Configuration

- Common commands:
  - `helm version`
  - `helm repo add` - Adds a chart repository to the system
  - `helm search repo` - Search a repo for a desired chart version
  - `helm install` - Deploy all kubernetes objects defined in a particular chart, `--dry-run` flag is also available
  - `helm list` - Get list of any releases (installed charts)
  - Managing releases:
    - `helm upgrade`
    - `helm rollback`
    - `helm history`
  - Creating charts:
    - `helm create` - Creates a chart with default files and structure
    - `helm package` - Create a chart archive from a chart directory, which can be pushed to a repo

---

## 1.5 - Configuration Demo

- Add the stable repository: `helm repo add stable https://charts.helm.sh/stable`
- Verify addition: `helm repo list`
- Search the repo for a chart: `helm search repo <repo name>/chart name`
  - Example: `helm search repo stable/mysql`
