# 5.10 - InitContainers

- In multi-container pods, each container will run a process that stays alive for the
duration of the pod's lifecycle
- Example: Consider a multi-container pod that runs a web application in one
container, and a logging agent in another
  - Both containers are expected to stay running at all times (the log agent runs
as long as the web application is running)
  - If either fails, the pod stops
- In some scenarios, would want to run a process that runs to completion in a
container e.g. a process that pulls a code or binary from a repository to be used by
the main application
  - Processes like this are to be ran only one time when the pod is first created,
or to wait for an external service or database to be up and running before
the application starts
- Containers like this are initContainers
- InitContainers are configured in the exact same way as regular containers in a pod's
spec, they are just a separate section to containers
  - When the POD is first created, the initContainer runs its progress to
completion before the main application starts
- Multiple initContainers can be configured in a similar manner to multi-container
pods
  - If this is the case, each initContainer will run one at a time
  - In the event any of the initContainers fail, the pod will repeatedly restart until
they all succeed
