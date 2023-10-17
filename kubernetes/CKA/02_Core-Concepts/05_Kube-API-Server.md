# 2.5 - Kube API Server

- The primary management component in Kubernetes
- When a kubectl command is ran, it is the Kube-API server that is contacted by the
kubectl utility for the desired action
- The kube-api-server authenticates and validates the request, then retrieves and
displays the requested information from the etcd server.
- Note: The kubectl command isn't always necessary to set the API server running.
  - Can instead send a post request requesting a resource creation such as:
■ `curl -X POST /api/v1/namespaces/default/pods ... [other]`
  - In this scenario, the following steps occur:
■ The request is authenticated
■ The request is validated
■ The API server creates a POD without assigning it to a node
■ Updates the information in the ETCD server and the user to inform of
the pod creation.
  - The updated information of the nodeless pod is acknowledged by the
scheduler; which monitors the API server continuously
■ The scheduler then identifies the appropriate node to place the pod
onto; communicating this back to the API server
  - The API server updates the ETCD server with this information and passes this
information to the kubelet in the chosen worker node
  - Kubelet agent creates the pod on the node and instructs the container
runtime engine to deploy the chosen application image.
  - Finally, the kubelet updates the API server with the change(s) in status of the
resources, which in turn updates the ETCD cluster's information.
- This pattern is loosely followed every time a change is requested within the cluster,
with the kube-api server at the centre of it all.
- In short, the Kube-api server is:
  - Responsible for validating requests
  - Retrieving and updating the ETCD data store
■ The API-Server is the only component that interacts directly with the
etcd data store
- Other components such as the scheduler and kubelet only use the API server to
perform updates in the cluster to their respective areas
- Note: The next point doesn't need to be considered if you bootstrapped your cluster
using kubeadm
  - If setting Kubernetes up "The Hard Way", the kube-apiserver is available asa
binary in the kubernetes release pages
  - Once downloaded and installed, you can configure it to run as a service on
your master node
- Kubernetes architecture consists of a lot of different components working with each
other and interacting with each other to know where they are and what they're
doing
  - Many different modes of authentication, authorization, encryption and
security, leading to many options and parameters being associated with the
API server.
- The options within the kube-apiserver's service file will be covered in detail later in
the notes, for now, the important ones are mainly certificates, such as:
  - `--etcd-certifile=/var/lib/kubernetes/kubernetes.pem`
  - `--kubelet-certificate-authority=/var/lib/kubernetes/ca.pem`
- Each of the components to be considered in this section will have their own
associated certificates.
- Note: To specify the location of the etcd servers, add the optional argument:
  - `--etcd-servers=https://127.0.0.1:2379`
■ Change IP address where appropriate or port, it's via this address the
kube-api-server communicates with the etcd server
- Viewing the options of the kube-api server in an existing cluster depends on how the
cluster was set up:
  - Kubeadm:
■ The kube-api server is deployed as a pod in the kube-system
namespace
■ Options can be viewed within the pod definition file at:
`/etc/kubernetes/manifests/kube-apiserver.yaml`
  - Non-kubeadm setup:
■ Options displayed in kube-apiserver.service file at
/etc/systemd/system/kube-apiserver.service
■ Alternatively, use `ps -aux | grep kube-apiserver` to view the process
and its associated options
