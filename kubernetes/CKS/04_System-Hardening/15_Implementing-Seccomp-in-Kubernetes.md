# 4.15 - Implementing Seccomp in Kubernetes

- By default, Docker supplies its own default seccomp profile in containers in mode 2
- When running in kubernetes, the number of blocked syscalls and seccomp
enablement may be different -> seccomp may not be enabled by default in Kubernetes (as of v1.20)
- To implement seccomp - use a pod definition file, to apply, need to add an appropriate field in the securityContext area:

  ```yaml
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  ```

- **Note:** When adding the profile in this manner, it is advised to add to the container's securityContext field a disabling of privilege escalation i.e.:

    ```yaml
    containers:
    - securityContext:
        allowPrivilegeEscalation: false
    ```

- This helps the application run ONLY with the Syscalls it requires for the process
- **Note:** Type can be set to Unconfined, but this is not recommended and is the default profile
- For custom profiles in the pod security context:

  ```yaml
  securityContext:
    seccompprofile:
      type: Localhost
      localhostProfile: <path to file>
  ```

- Note: The profile path must be relative to the default seccomp file in `/var/lib/kubelet/seccomp`
- Example:
  - Creating an audit seccomp profile with `defaultAction SCMP_ACT_LOG`
  - Syscalls from the container will be stored in `/var/log/syscall`
    - Logs user id, process ID, etc about the processes used
  - To help map the syscall numbers to syscalls is to check the following: `grep -w 35 /usr/include/asm/unistd_64.sh`
  - Where 35 can be replaced with the PID
- Tracee can also be used for this as discussed previously
- Consider another seccomp profile that rejects by default (`defaultAction = SCMP_ACT_ERRNO`) => any pod created with this cannot run as all Syscalls are blocked by default
- Once the Syscalls are analysed and audited, users can identify the allowed syscalls and add them to a custom seccomp profile => recommended to block all by default and allow only ones needed.
- **Note:** A custom seccomp profile won't be required to be created from scratch, but a template one may need to be attached to a pod/deployment etc.
