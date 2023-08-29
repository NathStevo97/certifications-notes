# 5.3 - Validating and Mutating Admission Controllers

- **Validating Admission Controller** - Allows or Denies a request depending on the controllers functionality/conditions
  - Example: NamespaceExists
- Mutating Admission Controller: If an object is to be created and a required parameter isn't specified, the object is modified to use the default value prior to creation
  - Example: DefaultStorageClass
- **Note:** Certain admission controllers can do both mutation and validation operations
- Typically, mutation admission controllers are called first, followed by validation controllers.
- Many admission controllers come pre-packaged with Kubernetes, but could also
want custom controllers:
  - To support custom admission controllers, Kubernetes has 2 available for use:
    - MutatingAdmissionWebhook
    - ValidatingAdmissionWebhook
  - Webhooks can be configured to point to servers internal or external to the cluster
    - Servers will have their own admission controller webhook services running the custom logic
    - Once all the built-in controllers are managed, the webhook is hit to call to the webhook server by passing a JSON object regarding the request
    - The admission webhook server then responds with an admissionreview object detailing the response
- To set up, the admission webhook server must be setup, then the admission controller should be setup via a webhook configuration object
  - The server can be deployed as an api server in any programming language desired e.g. Go, Python, the only requirement is that it must be able to accept and handle the requests
    - Can have a validate and mutate call
  - **Note:** For exam purposes, need to only understand the functionality of the webhook server, not the actual code
- The webook server can be ran in whatever manner desired e.g. a server, or a deployment in kubernetes
  - Latter requires it to be exposed as a service for access
- The webhook configuration object then needs to be created (validating example
follows):
- Each configuration object contains the following:
  - **Name** - id for server
  - **Clientconfig** - determines how the webhook server should be contacted - via URL or service name
    - **Note:** for service-based configuration, communication needs to be authenticated via a CA, so a caBundle needs to be provided
  - **Rules:**
    - Determines when the webhook server needs to be called i.e. for what sort of requests should invoke the call to the webhook server
    - Attributes detailed include API Groups, namespaces, and resources.

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: "pod-policy.example.com"
webhooks:
- name: "pod-policy.example.com"
  clientConfig:
    service:
      namespace: "webhook-namespace"
      name: "webhook-service"
    caBundle: "Ci0tLS0tQk.......tLS0K"
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE"]
    resources: ["pods"]
    scope: "Namespaced"
```