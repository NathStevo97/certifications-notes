# 8.3 - Container Storage Interface (CSI)

- CRI = Container Runtime Interface
  - Configures how Kubernetes interacts with container runtimes, such as
Docker
- CNI - Container Network Interface
  - Sets predefined standards for networking solutions to work with Kubernetes
- CSI - Container Storage Interface
  - Sets standards for storage drivers to be able to work with kubernetes
  - Examples include Amazon EBS, Portworx
- All of the above allow any container orchestration to work with drivers available