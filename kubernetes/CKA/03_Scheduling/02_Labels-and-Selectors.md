# 3.2 - Labels and Selcectors

- Built-In Kubernetes features used to help distinguish objects of similar nature from
one another by grouping them
- Labels are added under the metadata section, where an infinite number of labels
can be added to the Kubernetes object in a key value format
- To filter objects with labels, use the kubectl get command and add the flag --selector
followed by the key-value pair in the format `key=value`

```shell
kubectl get <object> --selector key=value
```

- Selectors are used to link objects to one another, for example, when writing a
replica set definition file, use the selector feature in the spec to specify the labels the
object should look for in pods to manage.
- The same can be applied to services to help identify what pods or deployments it is
exposing.
- Annotations - Used to record data associated with the object for integration
purposes e.g. version number, build name etc
