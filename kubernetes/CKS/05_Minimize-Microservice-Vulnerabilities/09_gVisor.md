# 5.9 - gVisor

- The Linux Kernel allows applications to perform an untold number of syscalls to
perform a variety of functions
- Whilst this can be great from a developer perspective, the same cannot be said for
security perspective. The more opportunities for Kernel interaction there are, the
more opportunities for attack.
- The core problem relates more to how each container in a multitenant environment
would be interacting with the same underlying OS and Kernel -> Need to improve
isolation from container-container AND from container-Kernel
- gVisor aims to implement the isolation between the container and Kernel.
  - When a program / container wants to make a syscall to the kernel, it first goes to gVisor
  - gVisor as a sandbox tool contains a variety of tools:
    - **Sentry** - An independent application-level Kernel dedicated for containers; intercepting and responding to syscalls
      - Sentry supports much less syscalls than the linux kernel as it's designed to support containers directly; limiting the opportunities for exploit.
    - **Gofer** - A file proxy that implements the logic for containers to access the filesystem
  - gVisor can also facilitate and monitor network-based operations.
  - Each container has its own gVisor Kernel acting between the container and the host kernel.
- The main con of gVisor is that its compatibility with applications can be limited, it can also result in slightly slower containers.