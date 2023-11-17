# 9.16 - Helm

## 9.16.1 - Helm Introduction

- Kubernetes is a fantastic tool for managing complex infrastructure and container orchestration.
- However, applications can get complex very quickly, such as requiring deployments, storage, secrets, and services.
- This can become difficult to maintain, Helm aims to ease this difficulty by packaging up the YAML files required for the application to be deployed all at once.
- These pacakages can then be updated, versioned, and rolled back as required. Similar to how deployments work, but for Kubernetes applications as a whole.

### Sample Commands

- Install/Deploy a chart: `helm install <chart name> ...`
- Upgrade a chart deployment: `helm upgrade <chart name> ...`
- Rollback a chart deployment: `helm rollback <chart name> ...`
- Uninstall a chart deployment: `helm uninstall <chart name> ...`

## 9.16.2 - Install Helm

- Helm installation requires a functional kubernetes cluster with `kubectl` enabled.
- Instructions are provided in the [Helm documentation](https://helm.sh/docs/intro/install/).

## 9.16.3 - Helm Concepts

- Helm charts are comprised of the collective YAML definitions required for the separate Kubernetes resources.
- It's not a case of **JUST** merge the YAML manifests together, considerations must be made, in particular, for values that are subject to change e.g.:
  - Passwords
  - Secret values
  - Storage parameters
  - Image versions
- The YAML manifests can be converted to Helm templates by replacing the values as Jinja variables i.e. `{{ .Values.<variable name> }}`
- The values themselves are stored in a `values.yaml` file e.g.:

```yaml
variable1: value1
variable2: value2
...
```

- The combination of templates and values files define a chart.
- Additionally, one includes a `chart.yaml` file, which provides background information regarding the chart, such as name, versions, keyword tags, source code repository links, etc.

### Helm Repositories

- Helm charts can be uploaded and viewed at [artifacthub.io](https://artifacthub.io).
- One can search for Helm chart repositories via ArtifactHub or via `helm search hub <chart name>`
- The repository(ies) desired can be addded via `helm repo add <repo name> <repo url>`
- The repo can then be searched for versions via `helm search repo <repo name>`

### Installing Charts

- Versions of charts can be installed as releases via `helm install <release name> <chart name>`
- The value for `<Release name>` is defined by the user at command execution, the same version of a chart can be installed multiple times under different release names.

### Additional Commands

- List installed charts: `helm list`
- Uninstall a release: `helm uninstall <release name>`
- Download a chart: `helm pull --untar <chart name>`
  - The `--untar` is included as charts are packaged in tarballs.
  - The chart can then be installed in a similar manner to the previous command, just replace chart name with the path to the downloaded chart tar.
