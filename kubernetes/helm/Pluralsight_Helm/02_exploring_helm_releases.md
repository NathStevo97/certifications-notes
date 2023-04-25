# 2.1 - Deploying a Chart to Kubernetes

- Releases = Instance of a chart running in Kubernetes.
- Add a repo via `helm repo add <repo name> <repo link>`
- Search for the chart you want, using mysql as an example from the stable repo:
  `helm search repo <repo name>/<chart name>`
- Install the chart:
  `helm install <release name> <repo name>/<chart name>`
- By default, if no version is provided, the latest version will be used.

# 2.2 - Chart Deployment Demo

- To view chart information in the CLI, use `helm show`:
  `helm show chart stable/mysql`
- Displays information such as sources, keywords, apiVersion, appVersion, and a description of the chart.
- To view the README: `helm show readme <repo name>/<chart name>`
- For ease, the README can be piped to a file for viewing, append `> /path/to/README.txt` for example
  - Displays parameters such as prerequisites and image(s) used

- Chart install general command: `helm install <release name> <repo name>/<chart name>`
  - Append `--dry-run --debug` for a test run and verbose output.

- Verify release via `helm list`

# 2.3 - Retrieving Information on Helm Releases

- Once a release has been deployed, the state of the release can be inspected by `helm list`
- By default, `helm list` will only check in the default namespace
- For releases in other namespaces, use `--namespace <namespace>` or `--all-namespaces`
- To view the status of the objects, use standard `kubectl` commands.

# 2.4 - Helm Release Information Retrieval Demo

- `helm list` to check the release
- Check the status of a release `helm status <release name>`
  - Shows information such as chart version
- Manifest version `helm get manifest <release name> > <filename>`
  - Shows the kubectl manifest YAMLs of all objects created, supplied with default values
- For custom values used during release deployment: `helm get values <release name> > /path/to/file`
- Get the notes associated with a chart: `helm get notes <release name> > /path/to/file`
- To get everything: `helm get all <release name> > /path/to/file`
- Use `kubectl get all` to get all kubernetes resources

- View helm chart release history: `helm history <release name>`
  - Provides details around all versions of a release

- Uninstall release but keep history: `helm uninstall <release name> --keep-history`
- Re-running without the `--keep-history` flag will completely uninstall the chart.

# 2.5 - Upgrading a Release

- To view all versions of a chart: `helm search repo <repo name>/<chart name> --version`
- To install a specific version: `helm install <release name> <repo name>/<chart name> --version <version>`
- Use `helm status` and `kubectl` commands to verify deployment
- To upgrade a release, use `helm upgrade <release name> <repo name>/<chart name> --version <new version>`
  - New resources (where required) will then be created
- Use `helm list` to review the release information and `helm history` to show the changes between revisions.

# 2.6 - Release Upgrade Demo

- Search for the repo `helm search repo <repo name>/<chart name>`
- Get all versions of the chart `helm search repo <repo name>/<chart name> --versions`
- Deploy the desired chart version: `helm install <release name> <repo name>/<chart name> --version <version>`
- Verify deployment with `helm list`
- Check the kubernetes objects `kubectl get all` (or appropriate e.g. use `--namespace`)
- Upgrade the release helm upgrade `<release name> <repo name>/<chart name> --version <new version>`
- Verify upgrade with `helm list`
- View the history of the release `helm history <release name>`

# 2.7 - Rolling Back a Release

- In the event of a rollback, use `helm rollback <release name> <revision number>`
- Use `helm list` and `kubectl` commands to verify deployment again

# 2.9 - Exploring a Chart

- To pull down a chart from a remote repository and view the files: `helm pull <repo>/<chart name> --untar`
- Charts by default contain the following:
  - Chart.yaml - Contains chart description
  - Values.yaml - Contains default values for the chart if not provided
  - Charts folder - Contains other charts that the main chart is dependent upon
  - Templates folder - Contains the primary YAML files used to generate Kubernetes Manifests

- Under templates folder, the manifests used to create Kubernetes objects e.g. deployments, services, etc.
  - `_helpers.tpl` - Used for supporting functions to be referenced by YAML files in the template directories
  - Notes.txt - Contains help text for the charts.

- Template YAMLs use Jinja templating to pass through variables / values set for the Helm chart, such as:
  - `name: {{ .Release.name }}-deployment`
  - `image: {{ .Values.containerImage }}`

- Values can be changed at runtime e.g. you may have specific values for Development and Production environments.
