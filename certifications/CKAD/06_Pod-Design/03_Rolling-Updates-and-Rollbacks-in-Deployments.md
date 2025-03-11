# 6.3 - Rolling Updates and Rollbacks in Deployments

## Rollout and Versioning

- When first creating a deployment, a rollout is triggered
  - Rollout = Deployment Revision
- When future upgrades occur, a new rollout and therefore a new revision of the deployment is created.
- This functionality allows tracking of deployment changes
  - Allows rollback capability in the event of application failure.

## Rollout Commands

- View rollout status: `kubectl rollout status <deployment name>`
- View rollout history and versioning: `kubectl rollout history <deployment name>`

## Deployment Strategy

- There are multiple deployment strategies available for applications, such as:
  - **Recreate Strategy:**
    - When a new version of an application is ready, tear down all current instances at once
    - Deploy new version once 'current' version is unavailable
    - This method causes significant downtime

  - **Rolling Updates:**
    - Destroy current instance and upgrade with new version one at a time
    - Leads to a higher application availability
    - Upgrade appears to be "seamless"

## Kubectl Apply

- To update a deployment, apply the appropriate changes to the associated definition file e.g. could update the image used, labels, etc.
  - Apply the changes: `kubectl apply -f <definition>.yaml`

- Changes can also be applied via the CLI directly, though this would not update the base definition YAML: `kubectl set image deployment/<deployment name> <image name>=<image name>:<new tag>`

- Deployment strategies can be viewed in detail for a given deployment via `kubectl describe deployment <deployment name>`
- For **recreate** strategy, during the upgrade process, one will see the deployment is gradually scaled down to 0 instances and back again.
- For **rolling update**:
  - Scaled down individually, old version is scaled down, then new version is brought up, this repeats per replicas.

## Upgrades

- When a new deployment's created, a new replicaset is automatically created, hosting the desired number of replica pods.
- During an upgrade, a new replicaset is created
  - New pods with new application version added sequentially
  - At the same time, the "old" pods are gradually taken down

- Once upgraded, if a rollback is required: `kubectl rollout undo <deployment name>`

## Kubectl Run

- The command `kubectl run <deployment name> --image <image name>` will create a deployment
  - This method acts as an alternative to using a definition file
  - Using this method, the required replicaset and pods auto-created in the backend.
- **Note:** It's highly recommended to use a definition file for deployments for file editing and versioning.

## Command Summary

- Create: `kubectl create -f <filename>.yaml`
- Get: `kubectl get deployments`
- Update a deployment: `kubectl apply -f <filename>.yaml` or `kubectl set image <deployment> <image ID>=<image>:<tag>`

- Apply an update via changes in a definition file or use CLI flags. The latter doesn't update any associated definition files stored on the system.

- Rollout Status: `kubectl rollout status <deploymment name>`
- Rollout History: `kubectl rollout history <deployment name>`

- Rollback: `kubectl rollout undo <deployment name>`

## Additional Notes

- Get the history of a particular deployment revision: `kubectl rollout history deployment <name> --revision=<revision number>`
- When updating a deployment revision, append the `--record` flag to save the command used to cause the revision update, this will be stored in the `change-cause` field of the above command's output.
- To rollback to a specific revision: `kubectl rollout undo deployment <name> --to-revision=<revision number>`
