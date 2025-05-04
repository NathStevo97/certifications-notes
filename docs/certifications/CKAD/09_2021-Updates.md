# 9.0 - 2021 Updates

- As of September 28th 2021, some changes have been made to the CKAD exam objectives. Certain exam objectives have been expanded upon and altered. In particular:
  - **Application Design and Build:**
    - *Design, build, and modify container images*
  - **Application Deployment:**
    - *Use Kubernetes Primitives to implement common deployment strategies e.g. blue/green, canary, etc.*
    - *Use the Helm package manager to deploy existing packages*
  - **Application Observability and Maintenance:**
    - *Understand API Deprecations*
  - **Application Environment, Configuration, and Security:**
    - *Discover and use resources that extend Kubernetes (CRD)*
    - *Understand authentication, authorization and admission control*

- Some of these are already talked about in CKA, however for completions sake we'll do them here too.

## 9.1 - Define, Build, and Modify Container Images

- When containerising an application, the image would typically follow the steps used to run the application locally e.g.:
  - Define the OS / Base Image
  - Install dependencies
  - Setup source code
  - Initialise the App

- An example follows for a sample Flask application:

```Dockerfile
FROM ubuntu

RUN apt-get update
RUN apt-get install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

- The image can then be built locally: `docker build Dockerfole -t <dockerhub Username>/<image name>`
- The image can then be pushed to Dockerhub `docker push <dockerhub username>/<image name>`

- The instructions defined in a Dockerfile are viewed as layered architecture, each layer only stores the changes defined from the previous. This is viewed during the Docker build as steps e.g. step 3/5.

- Each layer is cached by Docker, in the event of step failure, it will continue from the last working step once the issue is fixed. This saves time when building images.

## 9.2 - Authentication, Authorization and Admission Control

- Controlling access to API Server is the top priority
- Need to define who can access the API Server through and what they can do
- Could use any of:
  - Files
  - Certificates
  - External authentication providers
  - Service Accounts
- By default, all pods within a cluster can access one another
- This can be restricted via the introduction of network policies.

## 9.3 - Authentication

- Authentication Mechanisms Available in Kubernetes for the API Server:
  - Static Password File
  - Static Token File
  - Certificates
  - Identity Services e.g. `LDAP`
- Suppose you have the user details in a file, you can pass this file as an option for
authentication in the kube-apiserver.service file adding the flag:
`--basic-auth-file=user-details.csv`
  - Restart the service after this change is done
- If the cluster is setup using Kubeadm, edit the yaml file and add the same option
  - Kubernetes will automatically update the apiserver once the change is made
- To authenticate using the credentials specified in this manner run a curl command
similar to:
`curl -v -k https://master-node-ip:6443/api/v1/pods -u "username:password"`
- Could also have a token file, specify using `--token-auth-file=user-details.csv`
- **Note:** These are not recommended authentication mechanisms
  - Should consider a volume mount when providing the auth file in a kubeadm
setup
  - Setup RBAC for new users
- Could also setup RBAC using YAML files to create rolebindings for each user

## 9.4 - KubeConfig

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
  - Context created to specify that the user `MyKubeAdmin` is the user that is used to access the cluster `MyKubeCluster`
- Config file defined in YAML file
  - `ApiVersion` = v1
  - `Kind` = Config
  - `Spec` includes the three sections defined previously, all of which are arrays
  - Under clusters: specify the cluster name, the certificate authority associated
and the server address
  - Under `users`, specify username and associated key(s) and certificate(s)
  - Under `contexts`:
    - Name format: `username@clustername`
    - Under context specify cluster name and users
  - Repeat for all clusters and users associated
- The file is automatically read by the kubectl utility
- Use current-context field in the yaml file to set the current context
- **CLI Commands:**
  - View current config file being used: `kubectl config view`
    - Default file automatically used if not specified
    - To view non-default config files, append: `--kubeconfig=/path/to/file`
  - To update current context: `kubectl config use-context <context-name>`
  - Other commands available via `kubectl config -h`
  - Default namespaces for particular contexts can be added also
- **Note:** for certificates in the config file, use the full path to specify the location
  - Alternatively use `certificate-authority-data` to list certificate in base64 format

## 9.5 - API Groups

- API Server accessible at master node IP address at port 6443
  - To get the version, append `/version` to a curl request to the above IP address
  - To get a list of pods, append `/api/v1/pods`
- Kubernetes' A:PI is split into multiple groups depending on the group's purpose such as
  - `/api` - core functionalities e.g. pods, namespaces, secrets
  - `/version` - viewing the version of the cluster
  - `/metrics` - used for monitoring cluster health
  - `/logs` - for integration with 3rd-party logging applications
  - `/apis` - named functionalities added to kubernetes over time such as deployments, replicasets, extensions
    - Each group has a version, resources, and actions associated with
them
  - `/healthz` - used for monitoring cluster health
- Use `curl http://localhost:6443 -k` to view the api groups, then append the group and grep name to see the subgroups within
- Note: Need to provide certificates to access the api server or use `kubectl proxy` to view
- Note: `kubectl proxy` is not the same as kube proxy, the former is an http proxy service to access the api server

## 9.6 - Authorization

- When adding users, need to ensure their access levels are sufficiently configured, so they cannot make any unwanted changes to the cluster
- This applies to any physical users, like developers, or virtual users like applications e.g. Jenkins
- Additional measures must be taken when sharing clusters with organizations or teams, so that they are restricted to their specific namespaces
- **Authorization mechanisms available are:**
  - Node-based
  - Attribute-Based
  - Rule-Based
  - WebHook-based
- **Node-Based:**
  - Requests to the kube-apiserver via users and the kubelet are handled via the Node Authorizer
  - Kubelets should be part of the system:nodes group
  - Any requests coming from a user with the name system-node and is aprt of
the system nodes group is authorized and granted access to the apiserver
- **ABAC - Attribute-Based**
  - For users wanting to access the cluster, you should create a policy in a JSON
format to determine what privileges the user gets, such as namespace
access, resource management and access, etc
  - Repeat for each users
  - Each policy must be edited manually for changes to be made, the kube
apiserver must be restarted to make the changes take effect
- **RBAC**
  - Instead of associating each user with a set of permissions, can create a role
which outlines a particular set of permissions
  - Assign users to the role
  - If any changes are to be made, it is just the role configuration that needs to
be changed
- **Webhook**
  - Use of third-party tools to help with authorization
  - If any requests are made to say the APIserver, the third party can verify if the request is valid or not
- **Note:** Additional authorization methods are available:
  - `AlwaysAllow` - Allows all requests without checks
  - `AlwaysDeny` - Denies all requests without checks
- Authorizations set by `--authorization` option in the apiserver's .service or .yaml file
- Can set modes for multiple-phase authorization, use `--authorization-mode` and list
the authorization methods

## 9.7 - Role-Based Access Control (RBAC)

- To create a role, create a YAML file
- Spec replaced with `rules`
  - Covers apiGroups, resources and verbs
- Multiple rules added by - `apiGroups` for each
  - Create the role using `kubectl create -f`
- To link the user to the role, need to create a Role Binding
- Under `metadata`:
  - Specify `subjects` - Users to be affected by the `rolebinding`, their associated
apiGroup for authorization
  - `RoleRef` - The role to be linked to the subject
- To view roles: `kubectl get roles`
- To view rolebindings: `kubectl get rolebindings`
- To get additional details: `kubectl describe role/rolebinding <name>`
- To check access level: `kubectl auth can-i <command/activity>`
- To check if a particular user can do an activity, append `--as <username>`
- To check if an activity can be done via a user in a particular namespace, append
`--namespace <namespace>`
- **Note:** Can restrict access to particular resources by adding resourceNames:
`["resource1", "resource2", ...]` to the role yaml file

## 9.8 - Cluster Roles

- Roles and role bindings are created for particular namespaces and control access to
resources in that particular namespace
- By default, roles and role bindings are applied to the default namespace
- In general, resources such as pods, replicasets are namespaced
- Cluster-scoped resources are resources that cannot be associated to any particular
namespace, such as:
  - `Persistentvolumes`
  - `Nodes`
- To switch view namespaced/cluster-scoped resources: `kubectl api-resources --namespaced=TRUE/FALSE`
- To authorize users to cluster-scoped resources, use cluster-roles and cluster-rolebindings
  - Could be used to configure node management across a cluster etc
- Cluster roles and role bindings are configured in the exact same manner as roles
and rolebindings; the only difference is the kind
- **Note:** Cluster roles and rolebindings can be applied to namespaced resources if desired, the user will then have access to the resources across all namespaces.

## 9.9 - Admission Controllers

- Commands are typically ran using the kubectl utility, these commands are sent to the kubeapi server and applied accordingly
  - To determine the validity of the command, it goes through an authentication process via certificates
  - Any kubectl commands come from users with a kubeconfig file containing
the certificates required
  - The determination of whether the process has permission to carry the task out is handled by RBAC authorization
    - Kubernetes Roles are used to support this.
- With RBAC, restrictions can be placed on resources for:
  - Operation-wide restrictions
  - Specific operation restrictions e.g. create pod of specific names
  - Namespace-scoped restrictions
- What happens if you want to go beyond this? For example:
  - Allow images from a specific registry
  - Only run as a particular user
  - Allow specific capabilities
  - Constrain the metadata to include specific information
- The above is handled by **Admission controllers**
  - Various pre-built admission controllers come with K8s:
    - `AlwaysPullImages`
    - `DefaultStorageClass`
    - `EventRateLimit`
    - `NamespaceExists`
- Example - `NamespaceExists`:
  - If creating a pod in a namespace that doesn't exist:
    - The request is authenticated and authorized
    - The request is then denied as the admission controller acknowledges that the namespace doesn't exist -> Request is denied
- To view admission controllers enabled by default: `kube-apiserver -h | grep enable-admission-plugins`
  - **Note:** For kubeadm setups, this must be run from the kube-apiserver control plane using kubectl

- Admission controllers can either be added to the .service file or the .yaml manifest depending on the setup:

```shell
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --enable-swagger-ui=true \\
  --etcd-servers=https://127.0.0.1:2379 \\
  --event-ttl=1h \\
  --runtime-configmap=api/all \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --v=2
  --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
```

```yaml
## /etc/kubernetes/manifests/kube-apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --authorization-mode=Node,RBAC
    - --advertise-address=172.17.0.107
    - --allow-privileged=true
    - --enabke-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
    image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
    name: kube-apiserver
```

- To disable a plugin use `--disable-admission-plugins=<plugin1>,<plugin2>, ....`
- **Note:** NamespaceAutoProvision is not enabled by default - it can be enabled by the
above menthods

## 3.10 - Validating and Mutating Admission Controllers

- **Validating Admission Controller** - Allows or Denies a request depending on the controllers functionality/conditions
  - **Example:** `NamespaceExists`
- Mutating Admission Controller: If an object is to be created and a required parameter isn't specified, the object is modified to use the default value prior to creation
  - **Example:** `DefaultStorageClass`
- **Note:** Certain admission controllers can do both mutation and validation operations
- Typically, mutation admission controllers are called first, followed by validation controllers.
- Many admission controllers come pre-packaged with Kubernetes, but could also
want custom controllers:
  - To support custom admission controllers, Kubernetes has 2 available for use:
    - MutatingAdmissionWebhook
    - ValidatingAdmissionWebhook
  - Webhooks can be configured to point to servers internal or external to the cluster
    - Servers will have their own admission controller webhook services running the custom logic
    - Once all the built-in controllers are managed, the webhook is hit to call to the webhook server by passing a JSON object regarding the request
    - The admission webhook server then responds with an admissionreview object detailing the response
- To set up, the admission webhook server must be setup, then the admission controller should be setup via a webhook configuration object
  - The server can be deployed as an api server in any programming language desired e.g. Go, Python, the only requirement is that it must be able to accept and handle the requests
    - Can have a validate and mutate call
  - **Note:** For exam purposes, need to only understand the functionality of the webhook server, not the actual code
- The webook server can be ran in whatever manner desired e.g. a server, or a deployment in kubernetes
  - Latter requires it to be exposed as a service for access
- The webhook configuration object then needs to be created (validating example
follows):
- Each configuration object contains the following:
  - **Name** - id for server
  - **Clientconfig** - determines how the webhook server should be contacted - via URL or service name
    - **Note:** for service-based configuration, communication needs to be authenticated via a CA, so a caBundle needs to be provided
  - **Rules:**
    - Determines when the webhook server needs to be called i.e. for what sort of requests should invoke the call to the webhook server
    - Attributes detailed include API Groups, namespaces, and resources.

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: "pod-policy.example.com"
webhooks:
- name: "pod-policy.example.com"
  clientConfig:
    service:
      namespace: "webhook-namespace"
      name: "webhook-service"
    caBundle: "Ci0tLS0tQk.......tLS0K"
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["pods"]
    scope: "Namespaced"
```

## 3.11 - API Versions & Deprecations

### API Versions

- Each API group has its own version.
- At `/v1`, the API group is in it's "General Availability" or "stable" version. Other versions are possible, a summary follows:

|              | Alpha                                               | Beta                                                       | GA (Stable)                                    |
|--------------|-----------------------------------------------------|------------------------------------------------------------|------------------------------------------------|
| Version Name | `vXalphaY`                                          | `vXbetaY`                                                  | `vX`                                           |
| Enabled      | No, enabled via flags                               | Yes, by default                                            | Yes, by default                                |
| Tests        | May lack E2E Tests                                  | E2E Tests                                                  | Conformance Tests                              |
| Reliability  | May have bugs                                       | May have minor bugs                                        | Highly Reliable                                |
| Support      | No committment, may be dropped                      | Commits defined to complete the feature and progress to GA | Expected to be present in many future releases |
| Audience     | Expert users interested in providing early feedback | Users interested in beta testing and providing feedback    | All users                                      |

- **Note:** An API Group can support multiple versions at the same time e.g. you could create the same Deployment using `apps/v1beta` and `apps/v1`, but only one can be the preferred version.
- The preferred version is the `apiVersion` that is queried via `kubectl` commands and converted to for storage in the ETCD server.
- A preferred version is listed when viewing the `APIGroup` under `preferredVersion`.
- There is no way to see the `storageVersion` easily, except for querying the `ETCD` database directly.
- APIGroups that are enabled / disabled can be controlled by the flags for the `kube-apiserver` via the `--runtime-config=<api version>` flag in a comma-separated list.

### API Deprecations

- A single API group can support multiple versions at the same time, but some versions may need to be shelved / have support dropped.
- There are rules put in place by Kubernetes' community to manage this, the **API Deprecation Policy**, some rules to highlight follow:

#### Rule 1

- API Elements may only be removed by incrementing the version of the API group.
- In an example scenario, suppose for a given API Group you have 2 components released as part of `v1alpha1`, component B proved unusable / unnecessary etc and was deemed suitable for removal.
  - Component B cannot just be removed from `v1alpha1`, it may only be removed by removing it from `v1alpha2`, the next incremental version.
  - In this scenario, YAML files would need to be changed to the new version, but the new release would need to support both versions.
  - The preferred version could still be set to `v1alpha2` only.

#### Rule 2

- API objects must be able to round-trip between API versions in a given release without information loss, with the exception of whole REST resources that do not exist in some versions.
- Suppose a new field was added to a component in `v1alpha2`, an equivalent field must be added to `v1alpha1` should the user convert back to the older API Version from the newer version.

#### Rule 4a

- As development progresses towards GA, older versions such as `v1alpha1` will need to be dropped.
- Suppose `v1alpha1` was first included with version `X` of Kubernetes, then `v1alpha2` in `X+1`, etc, what happens to `v1alpha1`?
- In the alpha phase there is no requirement to maintain support for a past release. Similar rules apply for `Beta` and `GA`.
- **Rule 4a:** *Other than the most recent API Versions in each track, older API versions must be supported after their announced deprecation for a duration of no less than:*
  - **GA:** *12 months or 3 releases (whichever is longer)*
  - **Beta:** *9 months or 3 releases (whichever is longer)*
  - **Alpha:** *0 Releases*

- These deprecations must be mentioned in changelogs for each version update.
- Similarly to above, when API version `v1beta1` is released with Kubernetes `X+2`, there is no requirement to keep the `v1alpha2` version support.
- `v1beta1` must then stay supported for 3 Kubernetes releases (with a note on deprecation) when `v1beta2` is released in `X+3`.
- The preferred or storage version cannot change until Kubernetes `X+4` This is due to Rule 4b.

#### Rule 4b

- *The preferred API version and the storage version for a given group may not advance until after a release has been made that supports both the new version and the previous version*

#### Rule 3

- An API Version in a given track may not be deprecated until a new API Version at least as stable is released.
- This means that GA can deprecate another GA version and Beta versions, Beta for other betas and alpha versions, etc.

---

### Kubectl Convert

- When clusters are upgraded, this is often packed with APIversion changes. Managing these changes can be very tedious for large amounts of manifest files.
- This process can be expedited by the `kubectl convert` plugin. Once installed, run `kubectl convert -f <old-file> --output-version <new api version>`
  - Example: `kubectl convert -f <deployment.yaml> --output-version apps/v1`
- The plugin may not be installed by default, however it can be installed via instructions in the Kubernetes documentation.

## 9.12 - Custom Resource Definition

- Whenever an object is created in Kubernetes, information regarding it is stored in the ETCD database.
- The ETCD database can then be queried for the resource's information via the `kubectl` commands.
- When it comes to actually creating and configuring the object, a `Controller` handles this responsibility.

- Controllers do not have to be created, some, like the DeploymentController, come pre-packaged with Kubernetes.
- They continuously monitor the ETCD database for changes to information for the resources they manage, and ensure that the changes are reflected in the cluster by applying or removing the configuration desired.

- Essentially all Kubernetes resources have an associated controller to support this process.
- For new kinds of resources being created, custom controllers and custom resource definitions are required. You cannot create a new kind of resource without some form of definition for it in the Kubernetes API.

### Custom Resource Definition

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: <CRD Name>
spec:
  scope: Namespaced # or not!
  groups: <api group to be used in resource>
  names:
    kind: <kind to be used>
    singular: <CRD Singular Name> # resource name to be called via `kubectl` commands
    plural: <CRD Plural Name> # display name when `kubectl api-resources` is ran - plural of the singular
    shortName:
    - <CRD shorthand> # Like how deployments has deploy as shorthand
  versions: # list each version supported
  - name: v1
    served: true
    storage: true
    schema: # the expected fields for the object's spec
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              <property1>:
                type: <type>
                <type parameter 1>: <value>
                <type parameter 2>: <value>
                ...
              <property2>:
                type: <type>
                <type parameter 1>: <value>
                <type parameter 2>: <value>
                ...
              ...
```

- Once the CRD is defined, it can be created via `kubectl create` commands as standard. For creating resources based off this CRD, a supporting controller must also be defined.

## 9.13 - Custom Controllers

- Controllers are any process or code that continuously monitors clusters for events associated with a specific type of Kubernetes objects, and can respond accordingly to said events to ensure the desired state determined by the ETCD database is maintained in the cluster.
- Kubernetes provides a base sample-controller repository to start off with.
- Most controllers are written in `Go`, so `controller.go` (or appropriate) is edited accordingly with the desired logic.
- The controller can be built by `go build -o <controller name> .`
- The controller can then be ran and pointed to the desired kubeconfig: `./<go executable> -kubeconfig=/path/to/kubeconfig`

- You may also package the controller as a Go Docker image and run it within the Kubernetes cluster as a pod.
- Expected questions in the exam may include defining a custom resource definition and WORKING WITH custom controllers.

## 9.14 - Operator Framework

- CRD and Custom Controllers, up until now, have been separate entities created manually. However, they can be packaged together and deployed via the **Operator Framework**.
- One of the most common examples of the Operator Framework being utilised is ETCD - via the operator framework, a series of CRDs and Controllers are available:

| CRD         | Custom Controller |
|-------------|-------------------|
| ETCDCluster | ETCD Controller   |
| ETCDBackup  | Backup Operator   |
| ETCDRestpre | Restore Operator  |

- Operators often support additional tasks typically carried out via users e.g. Backup and Restore, as outline above.
- Operators are also available at [OperatorHub.io](https://operatorhub.io). Many common apps and tools are available via this, such as Grafana, Istio, ArgoCD, etc.
- Each operator can be viewed individually for specific details on installation, etc.
- It is expected to require awareness regarding operators, CRDs are the more likely candidate for any exam questions.

## 9.15 - Deployment Strategies

- Previously, the `recreate` and `rolling update` deployment strategies were considered.
- `Recreate` poses problems as there is a period of time where the app cannot be accessed, as all replicas are torn down before the new versions are spun up,
- `Rolling Update` is the default approach that mitigates this.

### 9.15.1 - Blue-Green

- In this scenario, two sets of the application are deployed, one typically receives all the traffic at any given point.
- The version not receiving traffic is used as a staging environment of sorts to test out new changes to the application.
- When the new version is ready, all traffic is routed to the new version instead of the old.
- The old version is then updated to the newer version, and the process repeats.

- This is commonly seen in conjunction with Service Mesh tools like Istio, but it can be achieved by Kubernetes alone.

- In Kubernetes, one can create two deployments, each labelled uniquely e.g. `version: v1`, `version: v2`.
- One can create a service that filters traffic by sharing the selector `version: v1` to the one deployment.
- When the time comes for switchover, the selector for the service can be updated to match that of the "newer" deployment.

### 9.15.2 - Canary

- In Canary deployments, the new version of the application is deployed alongside the old.
- A small percentage of traffic originally being routed to the old application is routed to the new one.
  - This allows initial functionality tests to be ran.
  - If all looks good, the remaining application instances are upgraded, and the initial test instance is destroyed.

- In Kubernetes, this is achieved by having an initial deployment and a service, typically it will be labelled accordingly.
- The "Canary" will be created as another deployment, this should be labelled accordingly to indicate the differing versions.
- When both of the deployments, traffic needs to be be routed to both of the versions, with a small percentage to the newer version.
- This can be achieved first by assigning a common label to the two deployments and updating the service's selector accordingly.
- The actions above will result in traffic being distributed evenly, to make it a more canary deployment, simply reduce the amount of the pods on the secondary deployment to the minimum amount desired e.g. 5 primary, 1 canary.

- A caveat of this method is that there is limited control over how the traffic is split between the deployments.
  - Traffic split is solely determined by pod numbers as far as Kubernetes is concerned.
  - Service Mesh tools like Istio do not view this as the case, and can fine-tune traffic splits via other methods.

## 9.16 - Helm

### 9.16.1 - Helm Introduction

- Kubernetes is a fantastic tool for managing complex infrastructure and container orchestration.
- However, applications can get complex very quickly, such as requiring deployments, storage, secrets, and services.
- This can become difficult to maintain, Helm aims to ease this difficulty by packaging up the YAML files required for the application to be deployed all at once.
- These pacakages can then be updated, versioned, and rolled back as required. Similar to how deployments work, but for Kubernetes applications as a whole.

#### Sample Commands

- Install/Deploy a chart: `helm install <chart name> ...`
- Upgrade a chart deployment: `helm upgrade <chart name> ...`
- Rollback a chart deployment: `helm rollback <chart name> ...`
- Uninstall a chart deployment: `helm uninstall <chart name> ...`

### 9.16.2 - Install Helm

- Helm installation requires a functional kubernetes cluster with `kubectl` enabled.
- Instructions are provided in the [Helm documentation](https://helm.sh/docs/intro/install/).

### 9.16.3 - Helm Concepts

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

#### Helm Repositories

- Helm charts can be uploaded and viewed at [artifacthub.io](https://artifacthub.io).
- One can search for Helm chart repositories via ArtifactHub or via `helm search hub <chart name>`
- The repository(ies) desired can be addded via `helm repo add <repo name> <repo url>`
- The repo can then be searched for versions via `helm search repo <repo name>`

#### Installing Charts

- Versions of charts can be installed as releases via `helm install <release name> <chart name>`
- The value for `<Release name>` is defined by the user at command execution, the same version of a chart can be installed multiple times under different release names.

#### Additional Commands

- List installed charts: `helm list`
- Uninstall a release: `helm uninstall <release name>`
- Download a chart: `helm pull --untar <chart name>`
  - The `--untar` is included as charts are packaged in tarballs.
  - The chart can then be installed in a similar manner to the previous command, just replace chart name with the path to the downloaded chart tar.
