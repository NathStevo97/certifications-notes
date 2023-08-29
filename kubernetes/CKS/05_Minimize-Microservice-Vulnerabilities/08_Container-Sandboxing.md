# 5.8 - Container Sandboxing

- All containers running on a server share the same underlying kernel. From the host perspective, this is just another process isolated from the host and other containers running it.
- When running a container running a process, the process will have a different process ID within the container and on the host OS.
  - This is process ID namespacing
    - Allows containers to isolate processes from one another
    - **Note:** If process killed on the host, the container would also be stopped
- For containers to run in the user space, they need to make syscalls to the hardware -> this leads to issues
  - Unlike VMs, which have dedicated Kernels, share the same Kernel on the host OS
  - This can pose massive security risks as it means that containers could interact and affect one another.
  - Sandboxing can resolve this
    - Sandboxing techniques include:
      - **Seccomp** - Docker default profiles and custom profiles (K8s)
      - **Apparmor**
    - Both of the above work by whitelisting and blacklisting actions and calls:
      - **Whitelist** - Block by default and allow particular calls / actions
      - **Blacklist** - Allow by default and block particular calls/actions
    - Both have varying use cases, there is no set case for what works best.