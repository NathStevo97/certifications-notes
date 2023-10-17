# 4.2 - Managing Application Logs

- When running a docker container in the background, one can view the associated
logs of a container by running `docker logs -f <container ID>`
- For kubernetes, run `kubectl logs -f <pod name>` for a standalone container
  - For a pod with multiple containers, you must specify the container name you
want to view, append this to the end of the above command
