# 4.8 - Identify and Disable Open Ports

- Several processes and services bind themselves to a network port on the system - an addressable location in the OS to allow for segregation of network traffic.
- Example - TCP port 22 is only used for SSH processes
- To understand if a port is in used and listening for a connection request:
  - `natstat -an | grep -w LISTEN`
- To understand what each service or port is being used for, can check in the services file under `/etc`
  - Example: `cat /etc/services | grep -w 53`
- This begs the question, what ports should be open for nodes on the Kubenetes cluster? Answer: Review the documentation!
- <https://kubernetes/doc.setup/production-environment/tools/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports>
