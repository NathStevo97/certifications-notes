# 13.1 - Troubleshooting Overview

## Application Failure

- Consider a 2-tier application, composed of a database and web server
- It's good practice to draw out the usual data flow for the application to help visualise
the failure
- E.g. suppose a user is complaining about accessibility issues
- Check accessibility from the frontend first:
  - Check if the web server is accessible on the IP of the node port using curl:
    - `curl http://<service-IP>:node-port`
  - Check the service to see if it has discovered the endpoints for the web pod
    - `kubectl describe service <Service-name>`
  - If the service didn't find the endpoints for the pod, check the
service-to-pod-discovery by comparing the selectors configured on the service and the pod respectively
  - Check the pod to ensure in a running state: kubectl get pods
    - Check running, restarts, logs and events
  - Repeat for db service and pods
  - Additional tips available via the Kubernetes documentation

## Control Plane Failure

- Check node status
- Check pod status on nodes
- Check kube-system pods
- Check services: `service <servicename> status`
- Check logs for each pod: `kubectl logs <podname> -n kube-system`

## Worker Node Failure

- Check node status and details (Describe)
  - See lastheartbeat field for last online time
- Check resource consumptions: kubectl top nodes
- Check the kubelet status: service kubelet status
- Check certs: `openssl x500 -in /var/lib/kubelet/<cert> -text`
- See if they're issued by the correct ca
