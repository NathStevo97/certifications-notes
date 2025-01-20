# 7.0 - Monitoring, Logging, and Runtime Security

## 7.1 - Perform Behavioural Analytics of Syscall Processes

- Various ways of securing kubernetes clusters have been discussed so far:
  - Securing kubernetes nodes
  - Minimizing microservices vulnerabilities
  - Sandboxing techniques
  - MTLS Encryption
  - Network Access Restriction
- No guarantee that utilising these 100% prevents the possibility of an attack, how can one prepare for the possibility?
In general for vulnerabilities, the sooner that the possibility of a vulnerability has
been exploited is noted, the better
- Actions that could be taken include:
  - Alert notifications
  - Rollbacks
  - Set limits for transactions or resource usage
- Identifying breaches that have already occurred can be done using tools like Falco
  - Syscalls can be monitored by tools like tracee
  - Need to analyse syscalls like these in real time to monitor events occurring
within the system and note any of suspicious nature
    - Example - Accessing a containers bash shell and going to the `/etc/shadow` section, deleting logs,

## 7.2 - Falco Overview and Installation

- For functionality, Falco must monitor the syscalls coming from the applications in
the user space into the linux kernel.
- This is done by a particular Kernel module - this is intrusive and forbidden by some
Kubernetes service providers
- A workaround is available via the eBPF in a similar manner to the Aquasec Tracee
tool.
- Syscalls are analysed by Sysdig libraries in the user space and filtered by the falco
policy engine based on predefined rules to determine the nature of the event.
- Alert notifications are sent via various methods including email and slack at the
users discretion.
- Steps are provided in the Falco getting started documentation for running it as a
service on Linux
- **Note:** In the event the Kubernetes cluster is compromised, Falco will still be running.
- Alternatively, Falco can be installed as a daemonset via installing the helm charts.
- Falco pods should then be running on all nodes.

## 7.3 - Use Falco to Detect Threats

- Check that falco is running:
  - `systemctl status falco` (if running on host)
- Creating a pod as normal, in a separate terminal, one can ssh into the node and run: `journalctl -fu falco`
  - This allows inspection of the events generated / picked up by the falco service
  - **Note:** the `fu` flag allows events to be automatically added as they appear
- In the original terminal, executing a shell in the pod generates an event picked up by falco.
  - Details displayed include pod, namespace, container name, commands ran, etc.
- The same is applied for any activity ran.
- Falco implements several rules by default to detect events, such as creating a shell and reading particular files.
  - Rules are defined in `rules.yaml` file.
  - Elements included: rules, lists and macros
  - Rules:
    - Defines all the conditions for which an event should be triggered
      - **Rule** - Name of the rule
      - **Desc** - What is the detailed explanation of the rule
      - **Condition** - filtering expression applied against events matching the rule
      - **Output** - output generated for any events matching the rule
      - **Priority** - severity of the rule

- Custom rule example - shell opening in a contaienr anywhere not equal to root:

```yaml
- rule: detect shell inside a container
  desc: alert if a shell such as bash is open inside the container
  condition: container.id != host and proc.name = bash
  output: bash shell opened (user=%user.name %container.id)
  priority: WARNING
```

- **Note:** Conditions are used via Sysdig filters e.g:
  - `container.id`
  - `fd.name` (file descriptor)
  - `evt.type` (event type)
  - `user.name`
  - `container.image.repository`
- Outputs can utilise similar filters to the above.
- Priority can be any of the following, amongst others:
  - EMERGENCY
  - ALERT
  - DEBUG
  - NOTICE
- **Note:** For a set of similar commands e.g. opening any possible shell for the container, lists can be used:

```yaml
- rule: detect shell inside a container
  desc: alert if a shell such as bash is open inside the container
  condition: container.id != host and proc.name = bash
  output: bash shell opened (user=%user.name %container.id)
  priority: WARNING

  - list: linux_shells
    items: [bash, zsh, ksh, sh, csh]
```

- Macros can be used to shorten filters e.g.:

```yaml
- macro: container
  condition: container.id != host
```

## 7.4 - Falco Configuration Files

- Main falco configuration file is located at /etc/falco/falco.yaml
  - Vieweable via either `journalctl -fu falco` or `/usr/lib/systemd/system/falco.service`
  - Contains all the configuration parameters associated with falco e.g. display format, output channel configuration etc.

- **Common options:**
  - How are rules loaded? Rules_file list
  - **Note:** The order of the rules files is important, as this is the order that falco will check them -> stick top priority rule files first.
  - Logging of events - what format or verbosity is used.
  - Minimum priority that should be logged determined by priority key (debug is the default)
  - Output channels:
    - `stdoutput` is set to true by default
    - Can configure output to a particular file in a similar manner or a particular program

```yaml
## Rules file prioritisation

rules_file:
- /etc/falco/falco_rules.yaml
- /etc/falco/falco_rules.local.yaml
- /etc/falco/k8s_audit_rules.yaml
- /etc/falco/rules.d

## Logging parameters:
json_output: false
log_stderr: true
log_syslog: true
log_level: info
```

```yaml
## Output channel example
file_output:
  enabled: true
  filename: /opt/falco/events.txt

program_output:
  enabled: true
  program: "jq '{text: .output}' | curl -d @- X POST https://hooks.slack.com/services/XXX"
```

- HTTP Endpoint Output Example:

```yaml
http_output:
  enabled: true
  url: http://some.url/some/path
```

- **Note:** For any changes made to this file, Falco must be restarted to take effect
- **Rules:**
  - Default file: `/etc/falco/falco_rules.yaml`
  - Any changes made to this file will be overwritten when updating the Falco package. To avoid, add to `/etc/falco/falc_rules.yaml`
- Example Config:

```yaml
- rule: Terminal Shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    A shell was spawned in a container with an attached terminal (user=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.name cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: NOTICE
```

- Hot reload can be used to avoid restarting the falco service and allow changes to take place:
  - Find the process ID of Falco at `/var/run/falco.pid`
  - Run a kill -l command: `kill -1 $(cat /var/run/falco.pid)`

### Reference Links

<https://falco.org/docs/getting-started/installation/>
<https://github.com/falcosecurity/charts/tree/master/falco>
<https://falco.org/docs/rules/supported-fields/>
<https://falco.org/docs/rules/default-macros/>
<https://falco.org/docs/configuration/>

## 7.5 - Mutable vs Immutable Infrastructure

- Software upgrades can be done via manual methods or using configuration tools such as custom scripts or configuration managers like ansible
- In high-availability setups, could apply the same update approach to each server
running the software - in-place updates
  - Configuration remains the same, but the software has changed
  - This leads to mutable infrastructure
- If the upgrade fails for a particular server due to dependency issues like network or files, a configuration drift can occur - each server behaves slightly differently to one another.
- To workaround, can just spin up new servers with the new updated software and delete the old servers upon successful updates
  - This is the idea behind immutable infrastructure - Unchanged infrastructure
- Immutability is one of the primary thoughts on containers
  - As they are made using images, any changes e.g. version updates should be applied to an image first, then that image is used to create new containers via rolling updates
  - **Note:** containers can be changed during runtime e.g. copying files to and
from containers - this is not in line with security best practices

## 7.6 - Ensure Immutability of Containers at Runtime

- Even though containers are designed to be immutable by default, there are ways to do in-place updates on them:
  - Copying files to containers:
    - `kubectl cp nginx.conf nginx:/etc/nginx`
    - `Kubectl cp <file name> <container name>:<target path>`
  - Executing a shell into the container and making changes:
    - `Kubectl exec -ti nginx -- bash nginx:/etc/nginx`

- To prevent this, one could add to the pod definition file security contexts in a similar manner to start with a readonly root file system e.g.:

```yaml
## nginx.yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    securityContext:
      readOnlyRootFileSystem: true
```

- This is generally not advisable for applications that may need to write to different directories like storing cache data, and so on.
- This can be worked around by using volumes:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: cache-volume
      mountPath: /var/cache/nginx
    - name: runtime-volume
      mountPath: /var/run
  volumes:
  - name: cache-volume
    emptyDir: {}
  - name: runtime-volume
    emptyDir: {}
```

- Considering the same file above, in the event this is being ran with privileged set to true, the read-only option will be overwritten -> even more proof that containers shouldn't run as root.
- In general:
  - Avoid setting `readOnlyRootFileSystem` as false
  - Avoid setting `privileged` to true and `runAsUser` to 0
- The above can be enforced via `PodSecurityPolicies` as discussed previously.

## 7.7 - Use Audit Logs to Monitor Access

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
