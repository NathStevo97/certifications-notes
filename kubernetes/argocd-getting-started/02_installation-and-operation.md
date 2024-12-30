# 2.0 - Installation and Operation of ArgoCD

- [2.0 - Installation and Operation of ArgoCD](#20---installation-and-operation-of-argocd)
  - [2.1 - Requirements](#21---requirements)
  - [2.2 - Deploying ArgoCD](#22---deploying-argocd)
    - [Installation](#installation)
  - [2.3 - Accessing ArgoCD API Server](#23---accessing-argocd-api-server)
  - [2.4 - Using the ArgoCD CLI](#24---using-the-argocd-cli)
    - [ArgoCD Installation](#argocd-installation)
    - [Common Commands](#common-commands)
  - [2.5 - Upgrading ArgoCD](#25---upgrading-argocd)
  - [2.6 - Setting Up RBAC for ArgoCD](#26---setting-up-rbac-for-argocd)
    - [**Default Roles:**](#default-roles)
    - [**ArgoCD RBAC - Resources \& Actions:**](#argocd-rbac---resources--actions)
    - [ArgoCD RBAC - Permissions](#argocd-rbac---permissions)
  - [2.7 - Configuring User Management](#27---configuring-user-management)
    - [Local Users](#local-users)
    - [SSO Integration](#sso-integration)
  - [2.8 - Setting Up Secrets Management](#28---setting-up-secrets-management)
  - [2.9 - HA, Backup and Disaster Recovery](#29---ha-backup-and-disaster-recovery)
    - [High-Availability](#high-availability)
    - [Backup and Disaster Recovery](#backup-and-disaster-recovery)
  - [2.10 - Monitoring and Notifications](#210---monitoring-and-notifications)
  - [2.11 - ArgoCD Monitoring](#211---argocd-monitoring)
    - [API Server Monitoring](#api-server-monitoring)
    - [App Monitoring](#app-monitoring)
    - [ArgoCD Notifications](#argocd-notifications)

## 2.1 - Requirements

- Kubectl needs to be installed
- A kubernetes cluster with:
  - Cluster admin level access
  - Kubeconfig configured to connect to the cluster
- Access to GitHub (or other source control)

## 2.2 - Deploying ArgoCD

- **Types of installs:**
  - **Non-High-Availability:**
    - Recommended for dev / testing
    - Deploys single pods and replicas for ArgoCD components
  - **High-Availability:**
    - Manifest = `namespace-install.yaml`
    - Recommended for prod
    - Optimized for high availabiltiy and resiliency
    - Multiple replicas for supported components.
  - **Core Install:**
    - Used typically when multi-tenancy features like web UI and API aren't required
    - Installs the non-HA version of each component
  - **Cluster Level:**
    - Use when you have cluster level access and will deploy apps in the saem K8s cluster that ArgoCD will run on
  - **Namespace-Level:**
    - Use when you have namespace-level access and will deploy apps to external K8s cluster from where ArgoCD is running.

### Installation

- Create a namespace for ArgoCD: `kubectl create namespace argocd`
- `kubectl apply -n argocd -f <link to install.yaml>`

- **Note:** Other methods of installation are available e.g. Helm.

## 2.3 - Accessing ArgoCD API Server

- 2 Ways:
  - Access the WebUI
  - Utilise the ArgoCD CLI.

## 2.4 - Using the ArgoCD CLI

- Certain activities can only be performed via the ArgoCD CLI in comparison to the UI, such as:
  - Adding clusters
  - Managing user accounts
- The CLI supports scripting and AUTOMATION

### ArgoCD Installation

- Windows: `choco install argocd-cli`
- Linux and Mac: `brew install argocd`\

### Common Commands

| argocd command | Description                                                           |
| -------------- | --------------------------------------------------------------------- |
| login          | Login to API Server                                                   |
| account        | Manage API Server Account                                             |
| proj           | Manage projects                                                       |
| app            | Manage applications                                                   |
| repo           | Manage repos used by ArgoCD                                           |
| version        | Check the argocd CLI version                                          |
| argocd-util    | Provides access to utilities to manage argocd e.g. import/export data |
| cluster        | Manage cluster operations                                             |

## 2.5 - Upgrading ArgoCD

- ArgoCD follows the standard semantic versioning `<MAJOR>.<MINOR>.<PATCH>`

## 2.6 - Setting Up RBAC for ArgoCD

- ArgoCD doesn't have RBAC enabled by default. When enabled, it facilitates restriction of access to ArgoCD Resources
- As ArgoCD doesn't have its own user management system, it requires SSO configuration for local setup:
  - Solutions such as Azure AD or Okta recommended for larger teams
- More RBAC roles beyond the defaults can be defined upon setup, which can then be assigned per user / group.

### **Default Roles:**

- `readonly`: Provide read-only access to all resources
- `admin`: unrestricted access to all resources

### **ArgoCD RBAC - Resources & Actions:**

- **Resources:** Clusters, projects, applications, repositories, certificates, accounts, gpgkeys
- **Actions:** get, create, update, delete, sync, override, action

### ArgoCD RBAC - Permissions

- Split into two caregories:
  - All resources except applications: `p, <role/user/group>, <resource>, <action>, <object>`
  - Applications (tied to an AppProject): `p, <role/user/group>, <resource>, <action>, <appproject>/<object>`

- These permissions and roles are typically defined in configmaps, where user groups are chosen by `g, <group name>`

## 2.7 - Configuring User Management

- By default ArgoCD has only one user created (admin)
- For new users there are 2 options:
  - **Local users** - Recommended for small teams 5 or less, as well as usage of API Accounts for automation.
  - **SSO Integration** - Recommended for larger teams & integrating with external identity providers.

### Local Users

- Stored in a ConfigMap that is applied to ArgoCD
- Lack access to advanced features e.g. groups, login history, etc.
- Each new user requires assignment to `readonly` or `admin` role, the two built-in roles.
- Each new user will also need policy rules defined, or they will default to `policy.default`
- New users are created in a ConfigMap named `argodc-cm`
- Users can have capabilities assigned:
  - `apiKey` - allows generation of api keys
  - `login` - allows login via the UI
- User management is only achievable via the CLI:
  - Get users: `argocd account list`
  - Get user details: `argocd account get --account <USERNAME>`
  - Set user password: `argocd account update-password`

### SSO Integration

- Also handled in the `argocd-cm` ConfigMap
- ArgoCD handles SSO via one of 2 options:
  - Dex OIDC Provider - Used when your standard identity provider doesn't support OIDC e.g. SAML or LDAP
  - Existing OIDC providers such as:
    - AuthO
    - Microsoft
    - Okta
    - OneLogin
    - KeyCloak

## 2.8 - Setting Up Secrets Management

- ArgoCD never returns sensitive data from its API, and redacts all sensitive data in API payloads and logs, including:
  - Cluster credentials
  - Git credentials
  - OAuth2 client secrets
  - Kubernetes Secret values
- ArgoCD stores the credentials of the external cluster as a Kubernetes Secret in the argocd namespace
  - The secret contains the K8s API bearer token associated with the `argocd-manager` service account created during the argocd setup.
- Secret management functionality isn't built-into ArgoCD by default, a third-party solution is required e.g.:
  - HashiCorp Vault
  - Helm Secrets
  - aws-secret-operator
  - argocd-vault-plugin

## 2.9 - HA, Backup and Disaster Recovery

- ArgoCD is made up of mostly stateless components
- For any data in ArgoCD that needs to persist, it is written to the etcd kubernetes database
- Redis in ArgoCD is designed as throwaway cache that will be thrown rebuilt when lost.
- Alternatively, ArgoCD can be deployed in a high-availability mode.

### High-Availability

- Requires at least 3 different nodes for pod anti-affinity roles
- Specific High-Availability Manifests required for deployment
  - Deploys more replicas of standard ArgoCD components and Redis in HA mode.
  - Comprised of two main YAML manifests:
    - `ha/install.yaml` - Deploys multiple replicas for supported ArgoCD components. Typically used when you have cluster-level access and will deploy apps in the same cluster that ArgoCD runs on.
    - `ha/namespace-install.yaml` - Deploys multiple replicas for supported ArgoCD components. Typically used when you have naespace-level access and will deploy apps to external clusters from where ArgoCD is running.

### Backup and Disaster Recovery

- Facilitated by `argocd admin` command, which supports data import and export operations:
  - `argocd admin export > backup.yaml`
  - `argocd admin import -< backup.yaml`

## 2.10 - Monitoring and Notifications

- API server supports webhooks and can be configured to receive webhook events instead of polling a given Git repository
- ArgoCD supports Git webhook notification from standard Git source control tools like GithUB and GitLab.

## 2.11 - ArgoCD Monitoring

- Two sets of Prometheus metrics are exposed: API Server Metrics, and Application Metrics
- ArgoCD has a built-in health assessment that is surfaced up to the overal Application health status.
  - Status determined by health checks on standard K8s  types e.g.:
    - Deployments
    - Service
    - Ingress
    - PersistentVolumeClaim

### API Server Monitoring

- Looking for API Server metrics, scraped to: `argocd-server-metrics:8083/metrics`
- Metrics are mostly associated with requests made to the API Servers, including:
  - Request Totals
  - Response codes

### App Monitoring

- Metrics scraped to `argocd-metrics:8082/metrics` including:
  - Gauge for application health status
  - Gauge for application sync status
  - Counter for application sync history

### ArgoCD Notifications

- Notification functionality is not built in natively to ArgoCD, alternatives are advised e.g.:
  - **ArgoCD Notifications:** An open-source notification system that monitors ArgoCD applications, it integrates with Slack, Discord, etc.
  - **Argo Kube Notifier**
  - **Kube Watch**
