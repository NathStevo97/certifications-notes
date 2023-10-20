# 2.17 - Namespaces

- A namespace is automatically created when a cluster is created
- They serve to isolate the cluster resources such that they aren't accidentally maniuplated.

- **Example:**
  - When developing an application, one can create a `Dev` and `Prod` namespace to keep resources isolated

- Each namespace can then have their own policies, detailing user access and controlm etc.
- Resource limits may also be namespace-scoped.

## DNS

- For objects communicating in their namespace, they simply refer to the other object by their name.
- Example, for a web application pod connecting to a database service titled `db-service`, you would specify: `mysql.connect("db-service")`.
- For objects communicating outside of their namespace, need to append the name of the namespace to access and communicate.
  - Example: `mysql.connect("db-service.dev.svc.cluster.local")`
  - In general format followed: `<service name>.<namespace>.svc.cluster.local`
- This can be done as when a service is created, a DNS entry is added automatically in this format.
- `cluster.local` is the default cluster's domain name.
- `svc` = subdomain for service.
- List all pods in default namespace: `kubectl get pods`
- List all pods in specific namespace: `kubectl get pods --namespace <namespace>`
- When creating a pod via a definition file, it will automatically be added to the default namespace if no namespace is specified.
- To add to a particular namespace: `kubectl create -f <definition>.yaml --namespace=<namespace name>`

- To set default namespace of a pod, add `namespace: <namespace name>` to metadata in the definition file.

- Namespaces can be created via YAML definitions:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: namespace-name
```

- To create: `kubectl create -f <namespace>.yaml`
- Alternatively: `kubectl create namespace <namespace name>`
- To switch context: `kubectl config set-context $(kubectl config current-context) --namespace=<namespace>`
- To view all pods in each namespace add `--all-namespaces` to the `get pods` commands.

## Resource Quota

- Creates limitations on resources for namespaces
- Created via definition file
- **Kind:** ResourceQuota
- **Spec:** must specify variables such as:
  - Pod numbers
  - Memory limits
  - CPU limits
  - Minimum requested/required CPU and Memory

- **Example:**

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
```
