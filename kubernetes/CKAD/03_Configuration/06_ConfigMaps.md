# 3.6 - ConfigMaps

- When there are multiple pod definition files, it becomes difficult to manage environment data.
- This information can be removed from the definition files and managed centrally via ConfigMaps
- Used to pass configuration data as key-value pairs in Kubernetes
- When a pod is created, one can inject the ConfigMap into the pod.
  - The key-value pairs are available to the pod as environment variables for the application within the pod.

- Configuring ConfigMaps involves 2 phases:
  - Create the ConfigMap
  - Inject it to the pod.

- Creation is achieved through standard means: `kubectl create configmap <configmap name>`
- Or if a YAML file exists: `kubectl create -f <filename>.yaml`

- Via the first method, one can automatically pass in key-value pairs: <br>
  `kubectl create configmap <configmap name> --from-literal=<key>=<value> --from-literal=<key2>=<value2>`

- Multiple uses of the `--from-literal=<key>=<value>` allows multiple variables to be added.
  - **Note:** This becomes difficult when too many config items are present.
- One can also create ConfigMaps from a file e.g. <br> `kubectl create configmap <configmap name> --from-file=/path/to/file`

## Creating a ConfigMap via Declaration

- Create a definition file:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```

- To create from the above: `kubectl create -f <filename>.yaml`

- Can create as many ConfigMaps and required, just ensure they are named appropriately.

- View ConfigMaps via `kubectl get configmaps`
- Get detailed information of a ConfigMap via `kubectl describe configmap <configmap name>`

- Configuring a pod with a ConfigMap:
  - In a pod definition file, under the containers in spec, add `envFrom:` list property.
  - Each item in the resultant list corresponds to a ConfigMap item.

- Example usage:

```yaml
envFrom:
- configMapRef:
    name: app-config
```

- Can apply the config file and pod definitions with the `kubectl create -f <pod definition>.yaml`

## Summary

- ConfigMaps can be used to inject environmental variables into pods
- Could also inject the data as a file or via a volume

### env

```yaml
envFrom:
- configMapRef:
    name: <configmap key name>
```

### single env

```yaml
env:
- name: <env name>
  valueFrom:
    configMapKeyRef:
      name: <configmap name>
      key: <configmap key name>
```

### Volumes

```yaml
volumes:
- name: app-config-volume
  configMap:
    name: app-config
```
