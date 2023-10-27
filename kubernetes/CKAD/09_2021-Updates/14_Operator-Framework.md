# 9.14 - Operator Framework

- CRD and Custom Controllers, up until now, have been separate entities created manually. However, they can be packaged together and deployed via the **Operator Framework**.
- One of the most common examples of the Operator Framework being utilised is ETCD - via the operator framework, a series of CRDs and Controllers are available:

| CRD         | Custom Controller |
|-------------|-------------------|
| ETCDCluster | ETCD Controller   |
| ETCDBackup  | Backup Operator   |
| ETCDRestpre | Restore Operator  |

- Operators often support additional tasks typically carried out via users e.g. Backup and Restore, as outline above.
- Operators are also available at [OperatorHub.io](https://operatorhub.io). Many common apps and tools are available via this, such as Grafana, Istio, ArgoCD, etc.
- Each operator can be viewed individually for specific details on installation, etc.
- It is expected to require awareness regarding operators, CRDs are the more likely candidate for any exam questions.