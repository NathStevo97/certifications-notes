# 3.24 - Network Policies

## Traffic Example

- Suppose we have the following setup of servers:
  - Web
  - API
  - Database
- Network traffic will be flowing through each of these servers across particular ports, for example:
- Web user requests and receives content from the web server on port 80 for HTTP
- Web server makes a request to the API over port 5000
- API requests for information from the database over port 3306 (e.g. if MySQL)

- 2 Types of Network Traffic in this setup:
  - **Ingress:** Traffic to a resource
  - **Egress:** Traffic sent out from a resource

- For the setup above, we could control traffic by allowing ONLY the following traffic to and from each resource across particular ports:
  - Web Server:
    - Ingress: 80 (HTTP)
    - Egress: 5000 (API port)
  - API Server:
    - Ingress: 5000
    - Egress: 3306 (MySQL Database Port)
  - Database Server:
    - Ingress: 3306

- Considering this from a Kubernetes perspective:
  - Each node, pod and service within the cluster has its own IP address
  - When working with networks in Kubernetes, it's expected that the pods should be able to communicate with one another, regardless of the olution to the project
    - No additional configuration required
- By default, Kubernetes has an "All-Allow" rule, allowing communication between any pod in the cluster.
  - This isn't best practice, particularly if working with resources that store very sensitive information e.g. databases.
  - To restrict the traffic, one can implement a network policy.

---

- A network policy is a Kubernetes object allowing only certain methods of network traffic to and from resources. An example follows:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: network-policy
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod
    ports:
    - protocol: TCP
      port: 3306
```

- The policy can then be created via `kubectl create -f ....`

- Network policies are enforced and supported by the network solution implemented on the cluster.
- Solutions that support network policies include:
  - kube-router
  - calico
  - romana
  - weave-net

- Flannel doesn't support Network Policies, they can still be created, but will not be enforced.

- Selectors available:
  - podSelector
  - namespaceSelector
  - ipBlock
