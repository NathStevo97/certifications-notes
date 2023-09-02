# 3.9 - Static Pods

- Kubelet relies on the kube-apiserver for instructions on what pods to load on its
respective node
- The instructions are determined by the kube scheduler which was stored in the etcd
server
- Considerations must be made if any of the kube-api server, scheduler and etcd
server are not present, as a worst case scenario, suppose none of them are
available
- Kubelet is capable of managing a node independently to an extent
  - The only thing kubelet knows to do is to create pods, however in this
scenario there's no api server to feed it the instructions based on yaml
definition files
  - To work around this, you can configure the kubelet to read the pod definition
files from a directory on the server designated to store information about
pods
  - Once configured, the Kubelet will periodically check the directory for any new
files, where it reads the information and creates pods based on the
information provided
- In addition to creating the pods, the kubelet would take actions to ensure the pod
remains running, i.e.:
  - if a pod crashes, kubelet will attempt to restart it
  - if any changes are made to any files within the directory, the kubelet will
recreate the pod to cause the changes to occur
- Pods created in this manner, without the intervention of the API server or any other
aspects of a kubernetes cluster, are Static Pods
- Note: Only pods could be created in this manner, objects such as Deployments and
Replicasets cannot be created in this manner
- To configure the "Desginated Folder" for the kubelet to look in for pod definition
files, add the following option to the kubelet service file `kubelet.service`; note the
directory could be any directory on the system: `--pod-manifest-path=/etc/kubernetes/manifests`
- Alternatively, you could create a yaml file to specify the path the kubelet should look
at, i.e. `staticPodPath: /etc/Kubernetes/manifests`, which can be referenced by adding
the `--config=/path/to/yaml/file` to the service file
  - Note this is the kubeadm approach
- Once static pods are created, they can be viewed by docker ps (can't use kubectl due
to no api server)
- It should be noted that even if the api server is present, both static pods and
traditional pods can be created
- The api server is made aware of the static pods because when the kubelet is part of
a cluster and creates static pods, it creates a mirror object in the kube api server
  - You can read details of the pod but cannot make changes via the kubectl edit
command, only via the actual manifest
- Note: the name of the pod is automatically appended with the name of the node it's
assigned to
- Because static pods are independent of the Kubernetes control plane, they can be
used to deploy the control plane components themselves as pods on a node
  - Install kubelet on all the master nodes
  - Create pod definition files that use docker images of the various control
plane components (api server, controller, etcd server etc)
  - Place the definition files in the chosen manifests folder
  - The pods will be deployed via the kubelet functionality
  - Note: By doing this, you don't have to download the associated binaries,
configure services or worry about services crashing
- In the event that any of these pods crash, they will automatically be restarted by
Kubelet with them being a static pod
- Note: To delete a static pod, you have to delete the yaml file associated with it from
the path configured

## Static Pods vs Daemonsets

| Static Pods                                            | Daemonsets                                            |
|--------------------------------------------------------|-------------------------------------------------------|
| Created via Kubelet                                    | Created via Kube-API Server (Daemonset controller)    |
| Used to deploy control plane components as static pods | Used to deploy monitoring and logging agents on nodes |
| Ignored by Kube-Scheduler                              | Ignored by Kube-Scheduler                             |