# 4.08 - Lab 11

## Objectives

- Configure Contour
- Deploy Contour

## Configure Contour

1. Using the terminal, navigate to the `contour` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/ingress/contour`

2. Copy the example values for Contour used with NSX Advanced Load Balancer.

    `cp vsphere/contour-data-values-lb.yaml.example contour-data-values.yaml`

## Deploy Contour

1. Using the terminal, navigate to the `contour` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/ingress/contour`

2. Set the kubectl context to the tkc-01 cluster.

    `kubectl config use-context tkc-01-admin@tkc-01`

3. Deploy the Contour namespace and roles.

    `kubectl apply -f namespace-role.yaml`

4. Create a Kubernetes secret by using the configuration values file.

    `kubectl create secret generic contour-data-values --from-file=values.yaml=contour-data-values.yaml -n tanzu-system-ingress`

5. Deploy the Contour extension.

    `kubectl apply -f contour-extension.yaml`

6. Verify the status of the deployment by using kubectl.

    `kubectl get app contour -n tanzu-system-ingress`

    Re-run the command until the status displays as `Reconcile succeeded`.

7. Verify the status of the deployment by using kapp.

    `kapp list -n tanzu-system-ingress`

    `kapp inspect --app contour-ctrl -n tanzu-system-ingress`

    In the vSphere Client, the tasks panel will show two VMs being created with the name Avi-se-xxxxx.

    Wait for the VMs to be created before continuing to the next step.

8. Display the load balancer IP address created for Contour.

    `kubectl get service -n tanzu-system-ingress`

    Because Envoy performs the data plane functionality for Contour, the external IP address is assigned to Envoy.
