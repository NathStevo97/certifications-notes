# 3.0 - Deployment and Management of Applications

## 3.1 - Register a Kubernetes Cluster with ArgoCD

- By default with an ArgoCD deployment, the cluster it is running on is set as "in-cluster" -> `https://kubernetes.default.svc`
- When apps are deployed, you deploy them to the "in-cluster" Kubernetes cluster, or to external clusters.
- External clusters must first be registered with ArgoCD, this is achieved via the CLI ONLY, but it can then be modified via the UI.
  - Common commands include:
    - `argocd cluster add` - Add a given cluster configuration to ArgoCD, it must exist in the `kubectl` config prior to execution
    - `argocd cluster get` - Get specific information about a cluster
    - `argocd cluster list` - List known clusters in a JSON format
    - `argocd cluster rm` - Remove a given cluster from ArgoCD management
    - `argocd cluster rotate-auth` - Rotate auth token for a cluster

- Once the cluster is added to the kubeconfig as a context:
  - Verify with `kubectl config get-contexts -o name`
  - Add the context to ArgoCD, installing a service account `argocd-manager` to that context's `kube-system` namespace via `argocd cluster add <context name>`

## 3.2 - Setting Up Projects in ArgoCD

- Projects: A logical grouping of apps in ArgoCD
- Projects serve multiple purposes including:
  - Restrict what Git repos can be deployed from
  - Restrict what clusters and namespaces can be deployed to
  - Restrict the kinds of objects that can be deployed
  - Define project roles, providing app RBAC
- Typically used when ArgoCD is required by multiple teams
- All applications must belong to a project.
  - During initial setup, a "Default Project" is created automatically. Any apps created will be assigned to this if no other projects exist.
  - The default project allows deployments from any source Git repo to any cluster for all resource types.
- Projects can be created and managed by the web UI or the CLI.
- For the CLI: `argocd proj create <project name> ... <parameters>`
- Common commandsL
  - `argocd proj list`
  - `argocd proj get`
  - `argocd proj delete`
  - `argocd proj add-destination`
  - `argocd proj add-source`
  - `argocd proj allow-cluster-resource`
  - `argocd proj allow-namespace`

## 3.3 - Using Repositories with ArgoCD

- ArgoCD can connect to public or private Git repository.
  - For private, connection options include HTTP, HTTPS, SSH and the Github App.

## 3.4 - Deploy an App Using ArgoCD

- Deployment is achievable by either the web UI or CLI
- For deployment, ArgoCD needs to be pointed to the desired specific Git repository, containing any of Kubernetes manifests, Helm chart(s) or Kustomize.
- Typical CLI command: `argocd app create <app name> --repo <github link> --path <path to resources in repo> --dest-server <kubernetes http address> --dest-namespace <namespace name>`

### App of Apps

- Apps can be created that creates other apps, this is the "App of Apps" pattern - a declaritive deployment of an app that consists of other apps deploying them at the same time.
- Sample App of Apps Architecture (as seen in `argoproj/argocd-example-apps` on GitHub):

```shell
|- chart.yaml
|- templates
|  |- guestbook.yaml
|  |- helm-dependency.yaml
|  |- helm-guestbook.yaml
|  |- kustomize-guestbook.yaml
|- values.yaml
```

## 3.5 - Application Sync and Rollback

- Most common sync used = Auto-Sync / Automatic Sync
  - ArgoCD applies every object in the application
  - It will sync when it detects differences between the Git repo and teh live state in the cluster.
- Alternative Sync Options:
  - **Selective Sync**
    - Syncs out-of-sync-resources ONLY
  - **Sync Windows**
    - Configurable windows of time when syncs happen
    - They can be set to allow or deny
    - They can apply to manual and automated syncs
    - Schedules are defined in cron format and can be targeted to applications, namespaces, and clusters
  - **Sync Phases and Waves**
    - ArgoCD executes a sync operation in 3 phases - pre-sync, sync, and post-sync
    - Each phase can have ne or more waves, ensuring certain resources are healthy before subsequent resources are synced.

### Rollback

- Rollbacks are typically used when apps aren't healthy, ArgoCD can support this by tracking an application's history and leveraging data cached in Redis.
- For rollbacks to work: Auto-Sync needs to be disabled
- Via the CLI: `argocd app rollback <app name> <history id> [flags]`

## 3.6 - Deleting Applications

- Apps can be deleted from the UI or CLI. 2 Delete options available:
  - **Non-Cascade Delete** - Deletes only the app
  - **Cascade Delete** - Deletes the app and associated resources
- Deletion via CLI:
  - `argocd app delete <app name> --cascade=false`
  - `argocd app delete <app name> --cascade`

## 3.7 - Application Health and Status Reporting

- The Web UI provides the most comprehensive way of monitoring the health status of ArgoCD applications
- Breakdowns are avaailable for health status, sync status, etc.
- Application-level breakdowns are also available.
