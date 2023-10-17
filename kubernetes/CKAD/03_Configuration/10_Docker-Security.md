# 3.11 - Docker Security

- Consider a host with Docker running on it.
  - The host will be running processes such as the Docker Daemon
- Containers aren't completely isolated from their host -> they share the same kernel
- In general, containers are separated by namespaces (Linux)
- All processes run by a container are run by the host, just in their own namespace
  - The container can only see its own process via `ps aux`

- In the host, all processes are visible, container processes have differing IDs depending on their namespace

## Security: Users

- Docker hosts can have root users as well as non-root users
- By default, Docker runs processes in containers as the root user.
  - True within and outside the container

- To edit the default user for the container, use `docker run` in a similar manner to: `docker run --user=<username> <container> <command>`

- To enforce security, one can add `USER` value to the Dockerfile
  - This automatically defines the user when the container is built and run.
- When running a container that defaults to the root user, Docker takes measures to prvent the root user from taking unnecessary actions via Linux Capabilities.

## Linux Capabilities

- Listed in `/usr/include/linux/capability.h`
- In containers, Docker applies limited capabilities by default
- To override, add `--cap-add <CAPABILITY NAME>` to the `docker run` command
- To remove: `--cap-drop <CAPABILITY NAME>` in a similar manner
- For all capabilities, add `--privileged` -> not recommended!
