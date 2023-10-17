# 7.2 - Falco Overview and Installation

- For functionality, Falco must monitor the syscalls coming from the applications in
the user space into the linux kernel.
- This is done by a particular Kernel module - this is intrusive and forbidden by some
Kubernetes service providers
- A workaround is available via the eBPF in a similar manner to the Aquasec Tracee
tool.
- Syscalls are analysed by Sysdig libraries in the user space and filtered by the falco
policy engine based on predefined rules to determine the nature of the event.
- Alert notifications are sent via various methods including email and slack at the
users discretion.
- Steps are provided in the Falco getting started documentation for running it as a
service on Linux
- **Note:** In the event the Kubernetes cluster is compromised, Falco will still be running.
- Alternatively, Falco can be installed as a daemonset via installing the helm charts.
- Falco pods should then be running on all nodes.
