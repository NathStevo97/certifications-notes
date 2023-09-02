# 7.14 - SecurityContext

- When running docker containers, can specify security standards such as the ID of
the user to run the container
- The same security standards can be applied to pods and their associated containers
- Configurations applied a pod level will apply to all containers within
- Any container-level security will override pod-level security
- To add security contexts, add securityContext to either or both the POD and
Container specs; where user IDs and capabilities can be set
