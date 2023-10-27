# 9.15 - Deployment Strategies

- Previously, the `recreate` and `rolling update` deployment strategies were considered.
- `Recreate` poses problems as there is a period of time where the app cannot be accessed, as all replicas are torn down before the new versions are spun up,
- `Rolling Update` is the default approach that mitigates this.

## 9.15.1 - Blue-Green

- In this scenario, two sets of the application are deployed, one typically receives all the traffic at any given point.
- The version not receiving traffic is used as a staging environment of sorts to test out new changes to the application.
- When the new version is ready, all traffic is routed to the new version instead of the old.
- The old version is then updated to the newer version, and the process repeats.

- This is commonly seen in conjunction with Service Mesh tools like Istio, but it can be achieved by Kubernetes alone.

- In Kubernetes, one can create two deployments, each labelled uniquely e.g. `version: v1`, `version: v2`.
- One can create a service that filters traffic by sharing the selector `version: v1` to the one deployment.
- When the time comes for switchover, the selector for the service can be updated to match that of the "newer" deployment.

## 9.15.2 - Canary
