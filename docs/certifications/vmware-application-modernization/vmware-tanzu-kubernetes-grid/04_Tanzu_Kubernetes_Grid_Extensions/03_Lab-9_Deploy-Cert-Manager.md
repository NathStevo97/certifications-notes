# 4.03 - Lab 9

## Objectives

- Deploy cert-manager

## Deploy Cert-Manager

1. Using the terminal, navigate to the `cert-manager` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/cert-manager`

2. Set the kubectl context to the tkc-01 cluster.

    `kubectl config use-context tkc-01-admin@tkc-01`

3. Deploy cert-manager.

    `kubectl apply -f .`

    Warning messages about deprecated objects can be ignored.

    This deploys:

    - namespace.yaml
    - cert-manager-crds.yaml
    - cert-manager.yaml (workload)
4. Verify the status of the deployment by using kubectl.

    `kubectl get pods -n cert-manager`

    Re-run the command until the pods display as running.
