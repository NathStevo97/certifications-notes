# 7.7 - Use Audit Logs to Monitor Access

- Previously seen how falco can produce details for events such as namespace, pod, and commands used in Kubernetes, but how can these be audited?
- Kubernetes allows auditing by default via the kube-apiserver.
- When making a request to the cluster, all requests go to the api server
  - When the request is made - it goes through **"RequestReceived"** stage - generates an event regardless of authentication and authorization
  - Once authenticated and authorized, stage is **ResponseStarted**
  - Once request completed - stage is **ResponseComplete**
  - In the event of an error - stage is **Panic**
  - Each of the above generate events, but this is not enabled by default, as a significant amount of unnecessary events would be recorded.
- In general, want to monitor only the events we actually care about, such as deleting pods from a particular namespace.

- This can be done by creating a policy object configuration file in a similar manner to below:

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages: ["RequestReceived"]
rules:
- namespaces: ["prod-namespaces"]
  verbs: ["delete"]
  resources:
  - groups: " "
    resources: ["pods"]
    resourceNames: ["webapp-pod"]
  level: RequestResponse

- level: Metadata
  resources:
  - groups: " "
    resources: ["secrets"]
```

- **Note:** omitStages is optional, define the stages you want to ignore in an array
- **Rules:** add each rule to be considered in a list, noting verbs, namespaces, resources where applicable, etc.
  - For resources, can specify the groups that they belong to and the resources within these groups
  - Additional refinement can be done via resourceNames
  - Level determines logging verbosity - none, metadata, request, etc.
- Auditing is disabled by default in Kubernetes, need to configure an auditing backend for the kube-apiserver, two types are supported: log file backend or webhook
service backend.
- The path to the audit-log file path must be added to the static pod definition
`--audit-log-path=/var/path/to/file`
- To point he apiserver to the policy to be referenced:
`--audit-policy-file=/path/to/file`
- Additional options include:
  - `--audit-log-maxage`: what is the longest a log will be kept for?
  - `--audit-log-maxbackup`: maximum number of log files to be retained on the
host
  - `--audit-log-maxisize`: maximum file size for given log files
- To test, carry out the event(s) described in the policy files.