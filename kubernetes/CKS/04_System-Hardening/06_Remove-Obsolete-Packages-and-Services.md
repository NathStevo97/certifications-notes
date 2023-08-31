# 4.6 - Remove Obsolete Packages and Services

- In general, systems should be kept as lean as possible, making sure that only the necessary software is installed and they are kept updated to address security fixes
- This can be applied for standalone systems, Kubernetes systems, etc.
- Any software that isn't used should be uninstalled for general reasons including:
  - Increased complexity of the system - one more package to maintain
  - It may remain unused and take up unwanted space
  - If not maintained, additional security vulnerabilities may arise that could be taken advantage of
- Removing services:
  - Services start applications upon Linux system booting
  - Managed by the Systemd tool and the systemctl utility
  - E.g. `systemctl status <service>`
    - Provides details regarding the service, including where its configuration file(s) are located
  - As with packages, only necessary services should be kept running or available on the system
    - To view the system services: systemctl list-units --type service
    - To remove a service: `systemctl stop <service>`
- Once services for unwanted packages are stopped, one can remove the associated package(s) via `apt remove <package name>`
- Additional information available in section 2 of the CIS Benchmarks.
