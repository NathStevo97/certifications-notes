# 7.6 - Ensure Immutability of Containers at Runtime

- Even though containers are designed to be immutable by default, there are ways to do in-place updates on them:
  - Copying files to containers:
    - `kubectl cp nginx.conf nginx:/etc/nginx`
    - `Kubectl cp <file name> <container name>:<target path>`
  - Executing a shell into the container and making changes:
    - `Kubectl exec -ti nginx -- bash nginx:/etc/nginx`

- To prevent this, one could add to the pod definition file security contexts in a similar manner to start with a readonly root file system e.g.:

```yaml
# nginx.yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    securityContext:
      readOnlyRootFileSystem: true
```

- This is generally not advisable for applications that may need to write to different directories like storing cache data, and so on.
- This can be worked around by using volumes:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: cache-volume
      mountPath: /var/cache/nginx
    - name: runtime-volume
      mountPath: /var/run
  volumes:
  - name: cache-volume
    emptyDir: {}
  - name: runtime-volume
    emptyDir: {}
```

- Considering the same file above, in the event this is being ran with privileged set to true, the read-only option will be overwritten -> even more proof that containers shouldn't run as root.
- In general:
  - Avoid setting `readOnlyRootFileSystem` as false
  - Avoid setting `privileged` to true and `runAsUser` to 0
- The above can be enforced via `PodSecurityPolicies` as discussed previously.
