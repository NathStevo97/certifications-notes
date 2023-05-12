# 6.6 - CronJobs

- A job that can be scheduled.
- Usually if a job was created via `kubectl create`, the job will run instantly
  - Not applicable for certain jobs e.g. logging

- To create a CronJob, can create a definition file similar to:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
  spec:
    schedule: "*/1 * * * *"
    jobTemplate:
      spec:
        completions: 3
        parralellism: 3
        template:
          spec:
            containers:
            - name: reporting-tool
              image: reporting-tool
        restartPolicy: Never
```

- **Note:** The format for the schedule property should adhere to: <br> `minute (0-59) hour (0-23) day (0-31) month (1-12) day (week, 0-6)`
- One can use `*` to act as a wildcard / "every" option.

- To create a CronJob: `kubectl create -f <cronjob>.yaml`

- To view CronJob: `kubectl get cronjob`