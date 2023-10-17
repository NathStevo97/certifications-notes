# 5.1 - Rolling Updates and Rollbacks

## Rollout and Versioning

- When first creating a deployment, a rollout is triggered
- Rollout is equivalent to a deployment revision in definition
- When future updates occur, a new rollout will occur creating a new deployment
revision
- This functionality allows tracking of deployment changes
  - Rollback functionality is therefore available in the event of application failure

## Rollout Commands

- To view rollout status:
  - `kubectl rollout status <deployment name>`
- To view rollout history and versioning:
  - `kubectl rollout history <deployment-name>`

## Deployment Strategy

- There are multiple deployment strategies available, the two main versions are:
  - Recreate:
    - When a new version of an application is ready, tear down all instances
currently deployed at once
    - Deploy new versions once "current" version is unavailable
    - Results in significant user downtime
  - Rolling Updates:
    - Destroys current instance and upgrades with a new version one after
another (take down one old version, upload a new version, repeat)
    - Leads to higher availability of the application
    - Upgrade appears "seamless"
- To update a deployment, simply make the changes to the definition file and run
`kubectl apply -f <deployment-definiton-file>.yaml`
  - This triggers a new rollout
- It should be noted, you could also update the deployment via the CLI only, for
example, updating a deployment's image:
  - `kubectl set image deployment <deployment-name> <image>=<image>:<tag>`
    - This method doesn't update the YAML file associated with the
deployment
- You can view deployment strategies in detail via the `kubectl describe deployment <deployment-name>`
  - For the recreate strategy, it can be seen that during the upgrade process the
deployment is scaled from maximum size, to zero, then back again
  - For rolling updates, the pods are scaled individually, one old pod removed,
one new pod added, and so on.
- When a new deployment is created, a new replicaset is automatically created,
hosting the desired number of replica pods
- During an upgrade a new replica set is created
  - New pods with new application added sequentially
  - At the same time, the new old pods are sequentially taken down
- Once upgraded, if a rollback is required, run: `kubectl rollout undo <deployment>`
- The command `kubectl run <deployment> --image=<image>` will create a deployment
  - Serves as an alternative to using a definition file
  - Required replicasets and pods automatically created in the backend
  - It's still highly recommended to use a definition file for editing and versioning
deployments
- Command Summary:
  - To create a deployment from a yaml file:
    - `kubectl create -f <deployment.yaml>`
  - To get a list of all deployments
    - kubectl get deployments
  - To update a deployment, run one of the following two:
    - `kubectl apply -f <deployment.yaml>`
    - `kubectl set image <deployment> <image ID>=<image>:<tag>`
  - To get the status of a deployment rollout:
    - `kubectl rollout status <deployment>`
  - To view the rollout history:
    - `kubectl rollout history <deployment>`
  - To rollback:
    - `kubectl rollout undo <deployment>`
