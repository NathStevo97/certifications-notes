# 14.3 - Installing the Loki Stack

## Prerequisites

- Loki stack shall be run in Kubernetes
- Ingress is to be handled (for demo purposes) by the Nginx Ingress Controller.
  - Ingress address to be accessed shall be stored by the env variable `INGRESS_HOST`.
- Helm:
  - General use and to deploy the demo app.

## Supporting Links

- [Gist with Commands](https://gist.github.com/vfarcic/838a3a716cd9eb3c1a539a8d404d2077)
- [DevOps Toolkit - Monitoring Folder](https://github.com/vfarcic/devops-catalog-code/tree/master/monitoring)

## Steps

1. Create a monitoring namespace
1. Add Loki Repo and `helm repo update`
1. Install loki - the default values are suitable for testing
1. Install Grafana
1. Prometheus and Loki must be added as data sources and Ingress must be set up - use the provided YAMl as a base, and use `--set ingress.hosts="{grafana.$INGRESS_HOST.xip.io}"`
1. Install Prometheus via Helm
1. Check all is running as expected with `kubectl --namespace monitoring get pods`

## Notes

- When Loki is installed, there are "promtail" pods running.
  - Promtail pods run as daemonsets
  - They ship the contents of local logs by discovering targets in a similar manner to Proemtheus service discovery
  - They label the logs and ship them to a Loki instance and/or Grafana
- Additionally, a central Loki instance(s) runs, which handles the processing of the logs picked up by the Promtail pods.
- The logs can be stored by any suitable format e.g. S3.

- Prometheus discovers targets, scrapes and processes the metrics, which can then be viewed in Grafana.
  - Metrics are collected by the various exporters.
