# 4.14 - Restricting Syscalls Using Seccomp

- Previously seen how to view syscalls in an os.
- In practice, ~435 syscalls are available in Linux, all can be used by applications in the user space.
- In reality, applications wouldn't need to use anywhere near as many syscalls - application should only be able to use the required syscalls for their application
- By default, the Linux Kernel allows any syscall to be invoked by programs in the user space - increasing attack surface
- To resolve, can utilise seccomp
  - Secure Computing - A linux kernel-native feature designed to constrain applications to only make the required syscalls
  - To check if host supports it, look in the boot config file: `grep -i seccomp /boot/config-$(uname -r)`
  - If `CONFIG_SECCOMP = y` -> seccomp is supported
- To demonstrate how applications can be finetuned, consider running a container
e.g. docker/whalesay:
  - `docker run docker/whalesay cowsay hello!`
  - Knowing the app works - can run the container and exec into it: `docker run -it --rm docker/whalesay /bin/sh`
    - If users wanted to change the time for example, it would not be allowed
- Process running is `shell/bin/sh`
- Inspecting the process id -> PID = 1
- Inspecting the PID can check via seccomp:
  - Grep seccomp `/prc/1/status`
  - If value = 2 -> seccomp enabled:
  - Modes:
    - 0 = Disabled
    - 1 = Strict -> Blocks all syscalls except read, write, exit, rt_sigreturn
    - 2 => Selectively filters syscalls
    - How was the seccomp filter applied? What restrictions has it got applied?
- Docker has seccomp enabled by default and restricts ~60 of the 435 syscalls
- Defined by json file(s)
  - Defines architectures for files
  - Syscall arrays -> names and actions (allow or deny)
  - Default action -> what to do with syscalls not defined in the syscall array
- Json files can act as whitelists or blacklists
  - Whitelists can be very restrictive as any which you do
want to run have to be added
  - Blacklists -> allows all by default bar any in the array;
more open than whitelists but more susceptible to
attacks
    - Default docker seccomp profiles block calls such as reboot, mount
and unmount, clock time managements
    - Default seccomp profiles are good but custom files are better for
particular scenarios
  - To utilise a custom seccomp profile, can add associated flag to the `docker run` command i.e.: <br> `docker run -it --rm --security-opt seccomp=/path/to/file.json docker/whalesay /bin/sh`
  - Seccomp can be disabled for containers completely by setting the flag to `--security-opt seccomp=unconfined`
    - SHOULD NEVER BE USED
