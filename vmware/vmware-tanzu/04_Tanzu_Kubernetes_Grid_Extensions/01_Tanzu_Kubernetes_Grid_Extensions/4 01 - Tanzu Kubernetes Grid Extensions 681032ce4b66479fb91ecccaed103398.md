# 4.01 - Tanzu Kubernetes Grid Extensions

Tags: Done

# Module Context

- Any standard Kubernetes installation will lack some of the functionalities required for production-level deployment.
- This is typically achieved by usage of extensions - TKG extensions provide functionality such as:
    - Logging
    - Ingress
    - Service Discovery
    - Monitoring

# Learner Objectives

- Describe the TKG Extensions and their functionalities

# About the TKG Extensions Bundle

- TKG extensions bundle includes binaries for tools to help provide in-cluster and shared services to your TKG instance
- VMware builds all the provided binaries and container images associated.

# Extensions Overview

- For each set of functionality, TKG extensions bundle typically has 1 preset extension readily available, though in the case of Monitoring, both Prometheus and Grafana are used in combination as standard practice.

![Untitled](4%2001%20-%20Tanzu%20Kubernetes%20Grid%20Extensions%20681032ce4b66479fb91ecccaed103398/Untitled.png)

- Note: Other options are available for each function e.g. NGINX, Traefik for Ingress

# Container Images

- VMware builds all container images used by Tanzu Kubernetes Grid and TKG extensions
- All container images are hosted on projects.registry.vmware.com
    - An instance of the Harbor image registry that’s managed by VMware
- For internet-restricted environments, container images can be copied to an accessible image registry
    - The extension manifest must then be updated to include the specific image registry

# Deployment with kapp-controller

- When extensions are deployed:
    - The namespace, configuration (-data-values.yaml), and extension (-extension.yaml) YAML files for the particular extension are applied.
    - kapp-controller combines the configuraiton with the YTT templates from the tkg-extensions-templates to generate all resource definitions required for the extension, such as:
        - Deployments
        - ConfigMaps
        - Secrets
    - The extension workload is then started using standard Kubernetes processes i.e. `kubectl apply`
    - Therefore, requests to deploy these extensions are passed from the kube-apiserver to the kapp-controller, which takes the templates from the tkg-extensions-templates and uses them to deploy the extensions.
- The kapp CLI can be used to inspect the state of workloads that are deployed by the kapp-controller.

![Untitled](4%2001%20-%20Tanzu%20Kubernetes%20Grid%20Extensions%20681032ce4b66479fb91ecccaed103398/Untitled%201.png)

# Configuring Extensions with Kubernetes Secrets

- Extensions are configured by creating a Kubernetes secret containing related configuration data
- The configuration file for each extension is defined in a file of format `<extension>-data-values.yaml` - this is used to create a Kubernetes secret named `<extension>-data-values`
- When kapp-controller deploys an extension, it reads the secret configuration to apply it to the extension
- Changes to the secret resource will automatically be picked up by the kapp-controller once the secret’s data is updated.

# Cert-Manager

- A native Kubernetes certificate management controller
- Functionalities include:
    - Add certificates and certificate issuers as resource types in Kubernetes clusters
    - Simplifies the process of obtaining/renewing/using certificates
    - Allows generation of certificates internally and connection to external services (e.g. Lets Encrypt) to request certifcates
- It’s not considered a TKG extension outright, however it is included in the extensions bundle as Contour, Grafana, Prometheus and Harbor all depend on its functionality to work.

# Deleting Extensions

- For troubleshooting or deletion of extensions, simply use `kubectl delete -f` against the YAML files associated with the extension i.e.:
    - `<extension>-extension.yaml`
    - `namespace-role.yaml`