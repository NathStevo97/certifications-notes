# 5.10 - Kata Containers

- Kata aims to set the isolation at its own VM / container
- Each container will have its own dedicated kernel running inside
- Removes the issue(s) when all container apps communicate with the same host
kernel -> if any issues occur, only the affected container will have issues
- The VMs created by Kata are lightweight and performance-focussed, therefore
would not take long to spin up.
  - The added isolation and VM would require additional resources
  - Additionally, there are compatibility issues for virtualization
- **Note:** Wouldn't want to run Kata on cloud instances / not be able to, this would be
nested virtualization and can lead to major performance issues.