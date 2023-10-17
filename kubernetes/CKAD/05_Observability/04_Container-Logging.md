# 5.4 - Container Logging

## Logs - Docker

- When running a container there are 2 main options:

1. Live / Forefront
    - `docker run <image>`
    - Displays live logs and processes associated with the container.
    - Good for testing standalone containers
2. Detached / Background
    - Recommended
    - `docker run -d <image>`

- To view the logs associated with the detached container: `docker logs -f <container id>`

## Logs - Kubernetes

- When running a pod in Kubernetes, you can view the container's logs via: `kubectl logs -f <pod name>`
- This only works for 1 container, what about 2?
  - Error will occur
  - To view specific container logs within a pod, run the above command and append the container name.
