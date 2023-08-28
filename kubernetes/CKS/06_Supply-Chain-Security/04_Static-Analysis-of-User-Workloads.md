# 6.4 - Static Analysis of User Workloads - Kubernetes resources, Docker Files, etc

- When submitting a resource creation request in kubernetes it goes through:
- Kubectl -> authentication -> authorisation -> admission controllers -> create
pod
- What if we want to catch any security vulnerabilities before using kubectl? Static
analysis can be used for this - resource files are reviewed against policies.
- Example tools - kubesec
  - Helps analyse a given resource definition file and returns a report with an associated score based on each vulnerability along with rationale regarding the vulnerability
- **Kubesec installation**
  - Installable via a [binary](https://kubesec.io/).
  - Run by `kubesec scan <pod.yaml>`
  - OR make a curl POST request:
    `curl -sSX POST --data-binary @"pod.yaml" https://v2.kubesec.io/scan`
  - OR: `kubecsec http 8080 &` - Runs a kubesec instance locally on the server
