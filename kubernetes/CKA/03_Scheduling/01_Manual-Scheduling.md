# 3.1 - Manual Scheduling

- When a pod is made available for scheduling, the Scheduler looks at the PODs definition file for the value associated with the field NodeName
- By default, NodeName's value isn't set and is added automatically when scheduling
- The scheduler looks at all pods currently on the system and checks if a value has been added to the NodeName field, any which do not are a candidate for scheduling.
- The scheduler identifies the best candidate for scheduling using its algorithm and schedules the pod onto that Node by adding the node's name to the NodeName field.
- This setting of the NodeName field value binds the Pod to the Node.
- If there is no scheduler to monitor and schedule the nodes, the pods will remain in a pending state.
- Pods can be manually assigned to nodes if a scheduler isn't present.
- This can be done by manually setting the pod's value for NodeName in the definition file.
- This can only be done before the pod is created for the first time, it cannot be done post-creation for a pre-existing pod
- To configure, as a child of the pod's Spec, add the field: `nodeName: <nodename>`
- Alternatively, you can assign a node by creating a binding object definition file to send a post request to the pod binding API; mimicking the scheduler's actions.

```yaml
apiVersion: v1
kind: Binding
metadata:
 name: nginx
target:
 apiVersion: v1
 kind: Node
 name: node02
```

- Once the binding definition file is written, a post request can be sent to the pod's binding API; with the data set to the binding object in a JSON format in a similar vein to:

```bash
curl --header "Content-Type:application/json" --request POST --data ‘{"apiVersion":"v1", "kind": "Binding" ...}

http://$SERVER/api/v1/namespaces/default/pods/$PODNAME/binding
```
