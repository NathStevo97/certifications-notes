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

## 9.15.2 - Canary

- In Canary deployments, the new version of the application is deployed alongside the old.
- A small percentage of traffic originally being routed to the old application is routed to the new one.
  - This allows initial functionality tests to be ran.
  - If all looks good, the remaining application instances are upgraded, and the initial test instance is destroyed.

- In Kubernetes, this is achieved by having an initial deployment and a service, typically it will be labelled accordingly.
- The "Canary" will be created as another deployment, this should be labelled accordingly to indicate the differing versions.
- When both of the deployments, traffic needs to be be routed to both of the versions, with a small percentage to the newer version.
- This can be achieved first by assigning a common label to the two deployments and updating the service's selector accordingly.
- The actions above will result in traffic being distributed evenly, to make it a more canary deployment, simply reduce the amount of the pods on the secondary deployment to the minimum amount desired e.g. 5 primary, 1 canary.

- A caveat of this method is that there is limited control over how the traffic is split between the deployments.
  - Traffic split is solely determined by pod numbers as far as Kubernetes is concerned.
  - Service Mesh tools like Istio do not view this as the case, and can fine-tune traffic splits via other methods.
