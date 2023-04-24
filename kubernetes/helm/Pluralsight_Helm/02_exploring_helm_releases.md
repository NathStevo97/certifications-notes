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

-  Verify release via `helm list`

# 2.3 - Retrieving Information on Helm Releases
# 2.4 - Helm Release Information Retrieval Demo
# 2.5 - Upgrading a Release
# 2.6 - Release Upgrade Demo
# 2.7 - Rolling Back a Release
# 2.8 - Rollback Demo
# 2.9 - Exploring a Chart