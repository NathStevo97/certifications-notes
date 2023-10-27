# 9.12 - Custom Resource Definition

- Whenever an object is created in Kubernetes, information regarding it is stored in the ETCD database.
- The ETCD database can then be queried for the resource's information via the `kubectl` commands.
- When it comes to actually creating and configuring the object, a `Controller` handles this responsibility.

- Controllers do not have to be created, some, like the DeploymentController, come pre-packaged with Kubernetes.
- They continuously monitor the ETCD database for changes to information for the resources they manage, and ensure that the changes are reflected in the cluster by applying or removing the configuration desired.

- Essentially all Kubernetes resources have an associated controller to support this process.
- For new kinds of resources being created, custom controllers and custom resource definitions are required. You cannot create a new kind of resource without some form of definition for it in the Kubernetes API.

## Custom Resource Definition

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
