# 6.3 - Whitelist Allowed Registries - Image Policy Webhook

- By default, any image can be pulled from any registry (private or open) in Kubernetes
- This is a huge security risk, as if a image is pulled from a non-approved registry, it could contain multiple vulnerabilities that can be taken advantage of
- In general, need to ensure images are pulled from approved registries only i.e.
sufficient governance
  - This can be handled using admission controllers as discussed previously
  - When a request comes in, the admission controller can check the registry
  - We can make an admission webhook server and configure the webhook admission controller to validate the registry provided, along with any messages
  - Alternatively:
    - Could deploy an OPA service - configure a validating webhook to connect to the opa service and check agains the rego policy
  - Alternatively again:
    - Could utilise a custom build imagepolicywebhook, which can communicate with an admission webhook server via an admission configuration file
- ImagePolicyWebHook Admission Config File:

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /path/to/config/file
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: true
```

- `defaultAllow: true` - if webhook not accessible, default behaviour allows pod to be created
  - Setting to false denies by default unless the exceptions are explicitly defined elsewhere
- Access to the admission webhook server is defined in the kubeconfig file

```yaml
# /path/to/kubeconfig-file

clusters:
- name: name-of-remote-imagepolicy-service
  cluster:
    certificate-authority: /path/to/ca.pem
    server: https://images.example.com/policy

users:
- name: name-of-api-server
  user:
    client-certificate: /path/to/cert.pem
    client-key: /path/to/key.pem
```

- Once setup, the admission controller can be added to the
`--enable-admission-plugins` flag in the kube-apiserver `.service` or `yaml` file as appropriate.
  - Additionally: pass `--admission-control-config-file=<path to config file>`
  - This is used to help enable the admission controller webhook and authenticate it appropriately
