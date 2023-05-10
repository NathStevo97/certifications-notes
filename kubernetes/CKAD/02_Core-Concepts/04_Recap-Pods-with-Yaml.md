# 2.4 - Recap: Pods with YAML

- Kubernetes uses YAML files as inputs for object creation e.g. pods, deployments, services.
- These YAML files always contain 4 key fields:
  - apiVersion:
    - Version of Kubernetes API used to create the object
    - Correct api version required for varying objects e.g. `v1` for Pods and Services, `apps/v1` for Deployments
  - kind:
    - type of object being created
  - metadata:
    - data referring to specifics of the object
    - Expressed as a dictionary
    - Labels: Children of metadata
      - Indents denote what metadata is related toa  child of a property
      - Used to differentiate pods
      - Any key-value pairs allowed in labels
  - spec:
    - specification containing additional information around the object
    - Written in a dictionary
    - `-` denotes first item in a dictionary

- To create a resource from YAML: `kubectl create -f <definition>.yaml`

- To view pods: `kubectl get pods`

- To view detailed info of a particular pod: `kubectl describe pod <pod name>`
