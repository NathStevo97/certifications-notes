# 3.10 - Multiple Schedulers

- The default scheduler has its own algorithm that takes into accounts variables such
as taints and tolerations and node affinity to distribute pods across nodes
- In the event that advanced conditions must be met for scheduling, such as placing
particular components on specific nodes after performing a task, the default
scheduler falls down
- To get around this, Kubernetes allows you to write your own scheduling algorithm to
be deployed as the new default scheduler or an additional scheduler
  - Via this, the default scheduler still runs for all usual purposes, but for the
particular task, the new scheduler takes over
- You can have as many schedulers as you like for a cluster
- When creating a pod or deployment, you can specify Kubernetes to use a particular
scheduler
- When downloading the binary for kube-scheduler, there is an option in he
kube-scheduler.service file that can be configured; --scheduler-name
  - Scheduler name is set to default-scheduler if not specified
- To deploy an additional scheduler, you can use the same kube-scheduler binary or
use one built by yourself
  - In either case, the two schedulers will run as their own services
  - It goes without saying that the two schedulers should have separate names
for differentiation purposes
- If a cluster has been created via the Kubeadm manner, schedulers are deployed via
yaml definition files, which you can then use to create additional schedulers by
copying the file
  - Note: customise the scheduler name with the --scheduler-name flag
- Note: The leader-elect option should be used when you have multiple copies of the
scheduler running on different master nodes
  - Usually observed in a high-availability setup where there are multiple master
nodes running the kube-scheduler process
  - If multiple copies of the same scheduler are running on different nodes, only
one can be active at a time
  - The leader-elect option helps in choosing a leading scheduler for activities, to
get multiple schedulers working, do the following:
■ If you don't have multiple master nodes running, set it to false
■ If you do have multiple masters, set an additional parameter to set a
lock object name
- This differentiates the new custom scheduler from the default
during the leader election process
- The custom scheduler can then be created using the definition file and deployed to
the kube-system namespace
- From here, pods can be created and configured to be scheduled by a particular
scheduler by adding the field schedulerName to its definition file
  - Note: Any pods created in this manner to be scheduled by the custom
scheduler will remain in a pending state if the scheduler wasn't configured
correctly
- To confirm the correct scheduler picked the pod up, use `kubectl get events`
- To view the logs associated with the scheduler, run: `kubectl logs <scheduler name> --namespace=kube-system`
