
# 3.0 - Configuring Helm Repositories

## 3.1 - Repository Overview

- Chart repository = Any HTTP server that can serve YAML or TAR files. Needs to be able to respond to GET requests.
- Contains an index.yaml file and packaged charts.
- Helm charts are commonly stored in the Helm hub at <https://hub.helm.sh>
- Helm charts can then be stored and managed within the UI.

## 3.2 - Packaging a Helm Chart

- To create a chart: `helm create <chart name>`
- Initializes a chart folder with the default files and structure.
- Default files included:
  - Templates folder:
    - tests folder: To store any tests defined to verify chart functionality
    - _helpers.tpl - Used to define supporting functions for template YAMLs.
    - Example YAML files for Kubernetes resources - deployment, ingress, service account.
    - Notes.txt - Contains chart deployment information e.g. "how to get started with it"

- Add the desired YAML files required for the chart under Templates.

- Install the chart: `helm install <chart name> /path/to/chart`
- Verify deployment with `helm list` and `kubectl` commands as required.
- Packaging the chart: `helm package <path to chart> --destination <path to local charts folder>`

## 3.3 - Packaging a Helm Chart Demo

- Create a chart: `helm create <chart name>`
- Check and make whatever edits are necessary to the chart folder in `./<chart name>` e.g. remove the default YAML folders.
  - Add content to the Notes.txt file under `templates` directory
- Deploy the chart: `helm install <release name> /path/to/chart`
- Verify with `helm list` and `kubectl` commands
- Delete the release: `helm delete <release name>`
- If required, update the Jinja template directives e.g. `{{ .Release.Name }}` or `{{ .Values.containerImage }}`
- Redeploy if required using the commands defined above.
- Use more detailed commands to verify customised values are set accordingly e.g. `-o jsonpath=<path to metadata>`
- To override a value defined in values.yaml, use `--set <value key>=<new value>`.
- Package the chart: `helm package <path to chart> <output path>`

## 3.4 - Creating a Local Helm Repository

- Chart museum - an open-source, cross-platform helm chart repository that supports multiple cloud backends and local usage
- Chart museum itself can be ran as a helm chart.
- Deployment: `helm install chartmuseum stable/chartmuseum --set env.open.DISABLE_API=false`
  - DISABLE_API allows pushing of chart repository.
- To connect, port-forwarding is required:
   `kubectl port-forward $POD_NAME 8080:8080 --namespace default`
  - Pod name can be obtained by
     `$POD_NAME=$(kubectl get pods -l "app=chartmuseum" -o jsonpath="{.items[0].metadata.name}")`

- Add chart museum repository:
  `helm repo add chartmuseum http://127.0.0.1:8080`

- Push to chart to chart museum:
    `curl --data-binary "@<chart tar name>" http://localhost:8080/api/charts`

- Searching chart museum:
  - Run `helm repo update` to update the chart-museum repository to recognize the pushed chart.

- Verify update with `helm search repo chartmuseum/<chart name>`

## 3.6 - Creating a Remote Helm Repository

- A Helm Repository can be any server that can serve YAML and TAR files, as well as responding to get requests.
- Options available include Chart Museum, Github, JFrog Artifactory

### 3.6.1 - Example: Github Repository

- Create a repository in Github via standard means and clone locally.
- Copy in the packaged chart (the .tgz file created via helm package)
- In the repo, run `helm repo index` - creates index.yaml, the file referenced by `helm search`
- Stage, commit, then push to the repository.
- Add Github repository as a local Helm repository:
  - Copy the RAW URL of the index.yaml file (minus the index.yaml)
  - Run `helm repo add <repo name> <RAW URL>`
- Search for the repo: `helm search repo <repo name>/<chart name>`
  - The index.yaml has been cached locally and is getting picked up by `helm search`.
