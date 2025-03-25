# 6.0 - Supply Chain Security

## 6.1 - Minimize Base Image Footprint

- **Base vs Parent Image**
  - **Parent image** - any image used to build a custom image
  - **Base image** - any image built from scratch
- **Note:** Parent vs Base image may be used interchangeably, not a major issue
- For these notes - base image = any image used to build a custom image
- **Best Practices for image building:**
  - Images shouldn't be built that contain multiple applications e.g. databases, applications
    - Images should be modular i.e. 1 for a DB, etc. They should each solve their own problem and have their own independent set of dependencies
    - Once deployed as containers, these images can be controlled individually for scaling
  - **Persist State:**
    - Data or state shouldn't be stored in containers as they are ephemeral in nature - one should be able to destroy and recreate a container without losing data
    - Store on an external volume or via a caching service
  - **Choosing a base image:**
    - Should always consider base images that suit the technical need of the solution being developed
    - Images can be viewed on Docker Hub
    - Areas to note when searching for a base image:
      - Is it from an official source?
      - Is it up to date?
  - **Slim/Minimal Images:**
    - Minimizing the size of the image allows quicker pulling and building
    - General steps that can be taken:
      - Create slim/minimal images
      - Find an official minimal image that exists
      - Only install necessary packages e.g. remove shells/package managers/tools - anything which one can use to infiltrate a system
      - Ensure images are suited to the environment that they are being used for e.g. for a development environment, include debug tools, for production, ensure as lean as possible
      - Use multi-stage builds - ensures lean, production-ready images
- **Distroless Docker Images**
  - Contain only the application and docker runtime dependencies
  - Provided by Google
- Minimizing image footprint leads to smaller area of attack for vulnerabilities -> more secure image

## 6.2 - Image Security

- Docker images follow the naming convention where `image: <image name>`
  - Image name = image / repository referenced
  - i.e. library/image name
    - Library = default account where docker official images are stored
    - If referencing from a particular account - swap library with account name
  - Images typically pulled from docker registry at docker.io by default
- Private repositories can also be referenced
  - Requires login via `docker login <registry name>`
  - It can then be referenced via the full path in the private registry
  - To facilitate the authentication - create a secret of type docker-registry i.e.:

`kubectl create secret docker-registry <name> --docker-server=<registry name> --docker-username=<username> --docker-password=<password> --docker-email=<email>`

Then, in the pod spec, add:

```yaml
imagePullSecrets:
- Name: <secret name>
```

## 6.3 - Whitelist Allowed Registries - Image Policy Webhook

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
## /path/to/kubeconfig-file

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

## 6.4 - Static Analysis of User Workloads - Kubernetes resources, Docker Files, etc

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

## 6.5 - Scan Images for Known Vulnerabilities (Trivy)

- **CVE = Common Vulnerabilities and Exposures**
- User-submitted database for vulnerabilities, workarounds and why it's an issue
- What constitutes a CVE?
  - Anything that can allow an attacker to bypass security checks and perform
unwanted actions
  - Anything that allows attackers to seriously affect application performance
- Each CVE gets a severity rating from 0-10 - helps to understand what vulnerabilities
should be shown greater focus etc
- In general, a higher score = greater vulnerability
- Example - Download from http instead of https gives a score of around 7.3
- Kubernetes clusters will have various processes and packages running at any given
point, the attack area can be minimized by actions such as deleting unnecessary
packages as discussed previously.
- To understand the current state of the cluster in terms of vulnerabilities across
processes, containers, and so on, one can utilise CVE Scanners
  - Container scanners look for vulnerabilities in container / execution
environment - applications in the container
  - Once vulnerabilities are identified, the appropriate action(s) can be taken e.g.
update versions, remove packages, etc
  - In general - more packages = greater footprint = greater amount of
vulnerabilities

### Example - Trivy

- Provided by AquaSecurity as a simple CVE scanner for containers, artifacts,
etc
- Can be integrated with CI/CD pipelines
- Can easily be installed as if installing a typical package
- To scan: `trivy image <image name>:<tag>`
- Additional flags available e.g.:
  - `--severity=<severity 1>,<severity 2>`
  - `--ignore-unfixed` (ignore any vulnerabilities that can't be fixed even if packages are updated)
- Trivy can be used to scan images in a tar format too e.g.:
  - `docker save <image> > <name>.tar`
  - `trivy image --input archive.tar`
- Reducing vulnerabilities can be done by using minimal images e.g. alpine images like nginx-alpine
- **Best practices:**
  - Continuously rescan images
  - Use kubernetes admission controllers to scan images
  - Use your own repository with pre-scanned images ready to go
  - Integrate container scanning into CI/CD pipelines
