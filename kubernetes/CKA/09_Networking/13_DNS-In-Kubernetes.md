# 9.13 - DNS in Kubernetes

- Consider a 3-node cluster with pods and services
- Nodenames and IP addresses stored in DNS server
- Want to consider cluster-specific DNS
- Kubernetes by default deploys a Cluster-DNS server
- Manual setup required otherwise
- Consider 2 pods with one running as a service, each pod being on different nodes
- Kubernetes DNS service creates a DNS record for any service created (name and IP
address)
- If in same namespace, just need `curl http://service`
- In different namespaces: `curl http://service.namespace`
- For each namespace, the kubernetes service creates a subdomain, with further
subdomains for services
- The full hierarchy would follow:
  - Cluster.local (root domain)
  - Svc
  - Namespace
  - Service name
- So to access the fill service, can run: `curl http://service.namespace.svc.cluster.local`
- Note: DNS records aren't created for pods by default, though this can be enabled
(next section)
- Once enabled, records are created for pods in the DNS server, however the pod
name is rewritten, replacing the dots in the pods IP address with dashes
- Pod can then be accessed via: `curl https://<pod hostname>.namespace.pod.cluster.local`
