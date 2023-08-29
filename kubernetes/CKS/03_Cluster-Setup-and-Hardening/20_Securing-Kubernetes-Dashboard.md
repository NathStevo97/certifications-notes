# 3.20 - Securing the Kubernetes Dashboard

- Various authentication methods available:
  - **Token:**
    - Requires user creation with sufficient permissions via RBAC
    - Kubernetes dashboard documentation provides instructions for this, but this is particularly geared towards cluster admins only.
    - In general, requires creation of user service accounts, roles and role bindings.
    - Once created, the token can be found by viewing the secret created relating to the service account.
  - **Kubeconfig:**
    - Requires passing of appropriate kubeconfig file that has the sufficient credentials to authenticate.

## References

- https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
- https://redlock.io/blog/cryptojacking-tesla
- https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
- https://github.com/kubernetes/dashboardhttps://www.youtube.com/watch?v=od8TnIvuADg
- https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca
- https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md