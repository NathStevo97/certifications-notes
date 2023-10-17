# 4.19 - Linux Capabilities

- Previously seen that even when running a container with an unconfined seccomp profile, it couldn't be manipulated
- The same is applicable to Kubernetes even though it doesn't use seccomp by default
- To understand this, need to review how processes run in Linux:
  - Processes are separated into privileged and unprivileged (for kernel versions less than 2.2)
  - For 2.2 onwards, processes are split into capabilities:
    - Privileged processes possess a number of capabilities e.g.:
      - `CAP_CHOWN`
      - `CAP_NETMODE`
      - `CAP_SYS_BOOT` - Allows reboots
  - To check the required capabilities for a command:
    - getcap /usr/bin/ping for example
  - For a process:
    - Get the PID: `ps -ef | grep /usr/sbin/sshd | grep -v grep`
    - `getpcaps <PID>`
- Pivoting back to the pod in the example, the reason the certain commands like the
change time couldn't work, the operation wasn't permitted
  - Even if ran as a root user, the container is only started with limited
capabilities (14 if Docker = runtime)
- Capabilities for a container can be managed at the container's security context:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper
spec:
  containers:
  - name: ubuntu-sleeper
    image: ubuntu
    command: ["sleep", "1000"]
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
```

- To drop a capability, add drop: `["Capability 1", "Capability 2", ...]`
