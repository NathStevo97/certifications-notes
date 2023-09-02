# 9.5 - Prerequisite: Docker Networking

- Run a docker container without attaching it to a network (specified by none
parameter) - `docker run --network none <containername>`
- Attach a container to a host's network - `docker run --network host <containername>`
  - For whatever the port the container runs on, it will be available on the same
port at the hosts IP address (localhost)
- Setup a private internal network which the docker host and containers attach
themselves to: `docker run <containername>`
- When docker's installed it creates a default network called bridge (when viewed by
docker) and `docker0` (when viewed via `ip link`)
- Whenever `docker run <containername>` is ran, it creates its own private namespace
(viewable via ip netns) and `docker inspect <namespace>`
- Port mapping:
  - For a container within the private network on the host, only the containers
within the network can view it
  - To allow external access, docker provides a port mapping option: appending `-p <hostport>:<containerport>` to the docker run command