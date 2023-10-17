# 5.2 - Liveness Probes

- Suppose you run an nginx docker image and is serving users:
  - In the event of this container failing, the service will stop, and will remain stopped until restarted; as Docker is not an orchestration tool.
- This problem can be fixed via Kubernetes' orchesteration. During application failure, Kubernetes will always try to restart failed containers to minimise user downtime.
- This will work fine so long as it's not an application-level issue.
  - If the container is working but the issue is at an application level, Kubernetes will see no issue. This is not good for user experience.

- To work around this, Liveness Probes can be leveraged to periodically test the application's health.

- If the test fails, the container is destroyed and recreated
- Test could be:
  - HTTP Test: Check a given route e.g. `/api/healthy`
  - TCP Test: Check connection to a given port e.g. 3306 (MySQL)
  - Exec a command and check the result

- As with readiness probe, configure the liveness probe in the pod's definition file for the particular container:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp
  labels:
    name: simple-webapp
spec:
  containers:
  - name: simple-webapp
    image: simple-webapp
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```

- Sample TCP liveness probe:

```yaml
livenessProbe:
  tcpSocket:
    port: 3306
```

- For a command execution:

```yaml
livenessProbe:
  exec:
    command:
    - cat
    - /app/is_ready
```

- Additionally, as with readiness probes, one can add parameters such as:
  - How long the test should wait before starting: `initialDelaySeconds`
  - How often should the test run: `periodSeconds`
  - How many successive failures are allowed: `failureThreshold`
