# 5.6 - OPA in Kubernetes

- Kubernetes currently has RBAC for various functions except:
  - Only permit images from certain registries
  - Forbid "runAs Root User"
  - Only allow certain capabilities
  - Enforce pod labelling
- Admission Controllers go some way to covering these failures, with many
pre-packaged with Kubernetes and capable of mutation and validation operations
however even they have their limitations.
  - For custom admission controllers, would have to build a separate admission
controller webhook server
  - This need can be removed and centralized by using OPA in kubernetes.
- Assuming OPA is pre-installed in Kubernetes, one can create a
ValidatingWebhookConfiguration:
  - If OPA is not installed in the Cluster, set the ClientConfig URL to the server
  - If installed on the server, one needs to define:
    - The OPA caBundle
    - The OPA Kubernetes service details
- As discussed, the webhook configuration sends an admission review request to the
OPA endpoint - in this case, the request is checked against the .rego policy stored
within OPA.
  - This can be for operations such as checking image registries.
- For policies where information about other pods is required, need to utilise an
import statement:
Import data.kubernetes.pods
- To help OPA understand the state / definition of the Kubernetes cluster in OPA, one
can use the kube-mgmt service
  - Service deployed as a sidecar container alongside OPA
  - Used to:
    - Replicate Kubernetes resources to OPA
    - Load policies into OPA via Kubernetes
- If creating an OPA policy, can create a ConfigMap with the
following label: openpolicyagent.org/policy: rego
And define the policy logic under the configMap's data field.
- How is OPA deployed on Kubernetes?
  - Deployed with kube-mgmt as a deployment
  - Roles and rolebindings deployed
  - Service to expose OPA service to Kubernetes API Server
  - Deployed in an OPA namespace.
- Within the cluster, one can now create a validating/mutating admission webhook
and reference the OPA service

```yaml
apiVersion: admissionregistration.k8s.io/v1beta1
kind: ValidatingWebhookConfiguration
metadata:
  name: opa-validating-webhook
webhooks:
- name: validating-webhook.openpolicyagent.org
  rules:
  - operations: ["CREATE", "UPDATE"]
    apiGroups: ["*"]
    apiVersions: ["*"]
    resources: ["*"]
  clientConfig:
    caBundle: $(cat car.crt | base64 | tr -d '\n')
    service:
      namespace: opa
      name: opa
```

- **Note:** The above is the "old" way of implementing OPA to Kubernetes, nowadays a
gatekeeper service is used.
