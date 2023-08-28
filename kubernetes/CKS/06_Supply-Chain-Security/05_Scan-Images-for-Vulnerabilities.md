# 6.5 - Scan Images for Known Vulnerabilities (Trivy)

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

## Example - Trivy

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
