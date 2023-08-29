# 3.18 - Kubectl Proxy and Port-Forward

- In the CKA Course, it was learned that the kubectl tool can be used to interact with the Kubernetes API server
- No API authentication required as it was applied in the kube config file
 - Kubectl can be found anywhere e.g. master node, a personal laptop (with a cluster
in a VM)
- No matter where the cluster is, so long as the kubeconfig is appropriately
configured with the security credentials, the kubectl tool can be used to manage it.
- Note: the api server could also be accessed via a curl command to the IP address
and port 6443
  - If done via this method, would also need to supply the certificate and key files, such that the curl command would be similar to: <br> `curl http://<kube-api-server-ip>:6443 -k --key admin.key --cert admin.crt --cacert car.crt`
- Alternatively, one can start a proxy client using kubectl
Kubectl proxy -> starts to serve on `localhost:8001`
  - Launches a proxy service and uses the credentials from the config file to access the API server
- Proxy only runs on laptop and is only accessible from this device
- By default, accepts traffic from the loopback address localhost -> not accessible from outside of the laptop.
- Can use kubectl proxy to make ANY request to the API server and services running within it.
- Consider an nginx pod exposed as a service only accessible within the cluster (if
clusterIP service):
  - Use kubectl proxy as part of a curl command: `curl http://localhost:8001/api/v1/namespaces/default/services/nginx/proxy/`
  - Allows access to remote clusters as if they were running locally
- Alternative: Port-Forward
  - Takes a resource (pod, deployment, etc) as an argument and specifies a port on the host that you would like traffic to be forwarded to (and the service port)
  - Example: `kubectl port-forward service/nginx 28080:80`
  - The service can then be accessed via curl http://localhost:28080/
- Allows remote access to any cluster service you have access to.
