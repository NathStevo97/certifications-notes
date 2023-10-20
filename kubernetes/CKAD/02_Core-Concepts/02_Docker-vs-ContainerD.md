# 2.2 - Docker vs ContainerD

## Background

- Began as the primary container runtime based on its enhanced user experience, Kubernetes was then introduced to orchestrate Docker containers ONLY.
- As Kubernetes grew in popularity, other container runtimes wanted to be able to work with Kubernetes.
- This led to the introduction of the **Container Runtime Interface (CRI)**.
- CRI allowed any vendor to work as a Container Runtime for Kubernetes, so long as they adhered to the **Open Container Initiative (OCI)** standards:
  - **imagespec** - standards for how a particular image is built.
  - **runtimespec** - standards for how a particular runtime should be developed.
- Docker wasn't built to support the CRI standards, to work around this, **dockershim** was introduced to support it as a container runtime interface in Kubernetes.
- Docker consists of multiple components in addition to the runtime, **runc** including:
  - API
  - CLI
  - VOLUMES
- The runtime for Docker, **runc**, ran by the daemon **containerd**, IS CRI compatible, and can be used outside of Docker on its own.
- Given this, maintaining Dockershim was deemed unnecessary, and Kubernetes support for it was therefore dropped from v1.24.

## ContainerD

- A standalone container runtime that can be installed without Docker.
- Comes with its own CLI tool `ctr` - advised only for debugging containerD and not much else.
- **Example commands:**
  - `ctr images pull docker.io/library/redis:alpine`
  - `ctr run <image url>:<tag> <container name>`

### NerdCTL

- Provides a Docker-like CLI for containerD, supporting docker-compose and the latest features in containerD such as:
  - Encrypted images
  - Lazy Pulling
  - P2P Image Distribution
  - Image signing and verifying
  - Namespaces in Kubernetes

- **Comparing Docker and NerdCTL Commands:**

| Command Goal                         | Docker Command                                  | NerdCTL Command                                  |
|--------------------------------------|-------------------------------------------------|--------------------------------------------------|
| Run a container                      | `docker run --name redis redis:alpine`          | `nerdctl run --name redis redis:alpine`          |
| Run a container with typical options | `docker run --name webserver -p 80:80 -d nginx` | `nerdctl run --name webserver -p 80:80 -d nginx` |

### CRIctl

- Provides a CLI for CRI-compatible container runtimes, installed separately to a given runtime.
- Used to inspect and debug container runtimes only, it does not do anything with running containers.
- Applicable to multiple runtimes.

- **Example commands:**
  - Pull an image: `crictl pull busybox`
  - List images: `crictl images`
  - Exec into a container: `crictl exec -i -t <container id> <command>`
  - List the logs of a container: `crictl logs <container id>`
  - Get Kubernetes pods: `crictl pods`

- Container runtime endpoints are called in the following priority by `crictl`:
  - `unix:///run/containerd/containerd.sock`
  - `unix:///run/crio/crio.sock`
  - `unix:///var/run/cri-dockerd.sock`
