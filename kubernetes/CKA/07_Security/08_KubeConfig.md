# 7.8 - KubeConfig

- Files containing information for different cluster configurations, such as:
  - -`-server`
  - `--client-key`
  - `--client-certificate`
  - `--certificate-authority`
- The existence of this file removes the need to specify the option in the CLI
- File located at `$HOME/.kube/config`
- KubeConfig Files contain 3 sections:
  - Clusters - Any cluster that the user has access to, local or cloud-based
  - Users - User accounts that have access to the clusters defined in the previous
section, each with their own privileges
  - Contexts - A merging of clusters and users, they define which user account
can access which cluster
- These config files do not involve creating new users, it's simply configuring what
existing users, given their current privileges, can access what cluster
- Removes the need to specify the user certificates and server addresses in each
kubectl command
  - `--server` spec listed under clusters
  - User keys and certificates listed in Users section
  - Context created to specify that the user "MyKubeAdmin" is the user that is
used to access the cluster "MyKubeCluster"
- Config file defined in YAML file
  - ApiVersion = v1
  - Kind = Config
  - Spec includes the three sections defined previously, all of which are arrays
  - Under clusters: specify the cluster name, the certificate authority associated
and the server address
  - Under users, specify username and associated key(s) and certificate(s)
  - Under contexts:
■ Name format: username@clustername
■ Under context specify cluster name and users
  - Repeat for all clusters and users associated
- The file is automatically read by the kubectl utility
- Use current-context field in the yaml file to set the current context
- **CLI Commands:**
  - View current config file being used: `kubectl config view`
■ Default file automatically used if not specified
■ To view non-default config files, append: `--kubeconfig=/path/to/file`
  - To update current context: `kubectl config use-context <context-name>`
  - Other commands available via `kubectl config -h`
  - Default namespaces for particular contexts can be added also
- **Note:** for certificates in the config file, use the full path to specify the location
  - Alternatively use certificate-authority-data to list certificate in base64 format
