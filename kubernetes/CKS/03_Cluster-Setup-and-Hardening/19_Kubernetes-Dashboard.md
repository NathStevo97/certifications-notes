# 3.19 - Kubernetes Dashboard

- A kubernetes sub-project used for a variety of functions including:
  - Get a graphical representation of your cluster
  - Monitor resource performance
  - Provision resources
  - View and manage secrets or not easily viewable resources.
- Due to these functionalities, it's important to ensure that the dashboard is secured appropriately.
- In earlier releases, access control was limited - led to many dashboard cyberattacks e.g. Tesla and Cryptocurrency mining.
- Deployment:
  - Can deploy by applying the recommended configuration from `https//<path-to-kubernetes-dashboard>/recommended.yaml`
  - **Deploys:**
    - **Namespace** - kubernetes-dashboard
    - **Service** - kubernetes-dashboard
    - **Secrets** - Certificates associated with the dashboard
  - **Note:** The service is not set to LoadBalancer by default, instead ClusterIP - this is in line with best practices so it is only accessible within the cluster VMs.
- **Accessing the Dashboard:**
  - Would typically want to access from the users laptop / device separate to the
cluster.
  - Access will require the kubectl utility and kubeconfig file, as well as kube
proxy.
  - Run `kubectl proxy` - proxies all the requests to the api server on the cluster to the machine running the proxy
    - Can then access the dashboard via `localhost:8001/<URL to Dashboard>` e.g.: `https://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/htpps:kubernetes-dashboard:/proxy`
  - Accessing the dashboard via a proxy is not applicable for teams requesting access to the dashboard.
    - Allowing access requires additional configuration to ensure only users of sufficient permissions have access - this is due to the ClusterIP service type.
    - **Possible solution:** set service type to LoadBalancer - not recommended as would make the dashboard public.
    - **Possible solution:** set service type to NodePort
      - This allows the dashboard to be accessible via the ports on the node, more advised than the previous suggestion assuming a sufficiently secure network.
    - Possible solution: Configure an Authentication Proxy e.g. OAuth2
      - Out of scope for the course, but a highly recommended option.
      - If users authenticate appropriately, traffic routed to Dashboard.
