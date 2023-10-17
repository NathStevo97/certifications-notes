# 3.17 - Kubelet Security

- Kubelet leads all the activities on a node to manage and maintain the node, carrying out actions such as:
  - Loading or unloading containers based on the kube-schedulers demands
  - Sending regular reports on worker node status to the api server
- Due to the importance of the kubelet, it's highly important to secure it and the communications between the kubernetes master node, api server, and worker nodes are secure.
- To refresh, the Kubelet, in worker nodes:
  - Registers the node with the cluster
  - Carries out instructions to run containers and container runtime
  - Monitor node and pod status on a regular basis
  - The kubelet can be installed as a binary file via a wget
    - Via kubeadm, it is automatically downloaded but not automatically deployed
- The kubelet configuration file varies in appearance. Previously, it was viewable as a .service file:

```shell
ExecStart=/usr/local/bin/kubelet \\
  --container-runtime=remote \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2 \\
  --cluster-domain=cluster.local \\
  --file-check-frequency=0s \\
  --healthz-port=10248 \\
  --cluster-dns=10.96.0.10 \\
  --http-check-frequency=0s \\
  --sync-frequency=0s
```

- Since kubernetes v1.10, options from --cluster-domain were moved to
kubelet-config.yaml for ease of configuration and management
- In the kubelet.service file, the kubelet-config file path is passed via the --config flag.
  - Note: any flags at CLI-level will override the .service file's value
- The kubeadm tool does not download or install the kubelet, but it can help manage
the kubelet configuration
  - Suppose there is a large number of worker nodes, rather than manually
creating the config file in each of the nodes, the kubeadm tool can help
automatically configure the kublet-config file associated with those nodes
when joining them to the master node.
- Once kubelet is configured, there a number of frequent commands that can be
used, including:
  - View the kubelet options:
    - `ps -aux | grep kubelet`
Views the associated options for the kubelet
    - `cat /var/lib/kublet/config.yaml`
View the config yaml for the kubelet
- Securing the kubelet, at a high level, involves taking actions to ensure the kubelet
responds only to the kube-apiserver's requests
- Kubelet serves on 2 ports:
  - 10250 - Serves API allowing full access
  - 10255 - Serves an API that allows unauthenticated read-only access
- By default, kubelet allows anonymous access to the api, e.g.
  - Running `curl -sk htpps://localhost:10250/pods/` reproduces a list of all the
pods
  - Running `curl -sk https://localhost:10250/logs/syslogs` returns the system
logs of the node that kubelet is running on
- For the service at 10255 - this provides access read-only access to metrics to any
unauthorized clients
- The above two services pose significant security risks, as anyone knowing the host IP
address for the node can identify information regarding the node and cause
damage if desired based on the various API calls available.
- Securing the kubelet boils down to authentication and authorization
  - Authentication determines whether the user can access the kubelet API
  - Authorization determines whether the user has sufficient permissions to
perform a particular task with the API
- **Authentication:**
  - By default, the kubelet permits all requests without authentication
  - Any requests are labelled to be from user groups "anonymous" part of an
unauthenticated group.
  - This can be disabled in either the kubelet.service file or the yaml file by
setting `--anonymous-auth` to false, as shown below:

```shell
# kubelet.service

ExecStart=/usr/local/bin/kubelet \\
    ...
    --anonymous-auth=false \\
    ...
```

```yaml
# kubelet-config.yaml

apiVersion: kubelet.config.k8s.io/v1beta1
kinds: KubeletConfiguration
authentication:
  anonymous:
    enabled: false
```

- Following the disabling of anonymous access, a recommended authentication
method needs to be enabled. Generally there are two to choose from:
  - Certificates (X509)
  - API Bearer Tokens
- Following the creation of a pair of certificates, the ca file should be provided via the following option in the kubelet service file: `--client-ca-file=/path/to/ca.crt` <br> Or to the `kubelet-config.yaml` file as shown below:

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kinds: KubeletConfiguration
authentication:
  x509:
    clientCAFile: /path/to/ca.crt
```

- Now that the certificate is configured, the client certificates must be supplied in any
curl commands made to the API i.e.: `curl -sk htpps://localhost:10250/pods/ -key kubelet-key.pem -cert kubelet-cert.pem`
- As far as the kubelet is concerned, the kube-apiserver is a client, therefore the apiserver should also have the kubelet client certificate and key configured in the apiserver's service configuration, as shown below:

```shell
# /etc/systemd/system/kube-apiserver.service

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  ...
  --kubelet-client-certificate=/path/to/kubelet-cert.pem \\
  --kubelet-client-key=/path/to/kubelet-key.pem \\
```

- **Remember:** the kube-apiserver is itself a server and therefore has its own set of certificates, all other kubernetes certificates will also require sufficient configurations
- **Note:** Kubeadm also uses this approach when trying to secure the kubelet
- **Note:** If neither of the above authentication mechanisms explicitly reject a request, the default behaviour of kubelet is to allow the request under the username
`system:anonymous` and group `system:unauthenticated`
- **Authorization:**
  - Once the user has access to the kubelet, what can they do with it?
  - By default, the mode AlwaysAllow is set, allowing all access to the API

    ```shell
    # kubelet.service

    ExecStart=/usr/local/bin/kubelet \\
        ...
        --authorization-mode=AlwaysAllow \\
        ...
    ```

    ```yaml
    apiVersion: kubelet.config.k8s.io/v1beta1
    kinds: KubeletConfiguration
    authorization:
    mode: AlwaysAllow
    ```

  - To change / rectify this, the authorization mode can be set to Webhook - the kubelet makes a call to the API server to determine if the request can be granted or not.
- Considering the metrics service running on 10255/metrics:
  - By default, this runs due to the kubelet config or service file having the `--read-only-port` set to 10255
  - If set to 0, the service is disabled and users cannot access it
- **Summary:**
  - By default, the kubelet allows anonymous authentication
  - To prevent this, you can set the `anonymous` flag to false - this can be done
either in the `kubelet.service` or `kubelet-config.yaml` files
  - Kubelet supports two authentication methods:
    - Certification-based authentication
    - API Bearer Tokens
  - By default, the authorization mode is set to "always allow" - this can be prevented by changing the mode to webhook to authorize via webhook calls to the kube-api server
  - By default, the readonly port is set to 10255, allowing unauthorized access to
critical kubernetes metrics, this can be disabled by setting the `--read-only-port` to 0.
