# 3.6 - Service Accounts

- In Kubernetes there are two types of accounts:
  - User - Used by Humans e.g. Administrators
  - Service - Used by application services for various tasks e.g. Monitoring, CI/CD
tools like Jenkins
- For an application to query the Kubernetes API, a service account is required
- Creation: kubectl create serviceaccount <serviceaccount name>
- View: kubectl get serviceaccount
- For detailed information: kubectl describe serviceaccount <name>
- When a serviceaccount is created, an authentication token is automatically created
for it and stored in a Kubernetes secret.
  - Serviceaccount token used for application authentication to the kube-api server
  - The secret can be viewed via kubectl describe secret <secret name>
  - This token can then be passed as an Authorization Bearer token when
making a curl request.
  - E.g `curl https://<IP-ADDRESS> -insecure --header "Authorization: Bearer <token>"`
- For 3rd party applications hosted on your own Kubernetes cluster:
  - The exporting of the service account token is not required
  - The service account secret can be mounted as a volume inside the pod hosting the application
- For every namespace, a default service account and its token are automatically assigned to a pod unless specified otherwise.
- Secret mounted as a volume for each pod - secret location viewable via `kubectl describe pod`
- **Note:** The default service account can only run basic Kubernetes API queries
- To specify a particular service account for a pod, add in the pod's spec field: `serviceAccount: name`
  - You must delete and recreate a pod if you wish to edit the service account on a pod.