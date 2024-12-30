# 4.12 - Lab 13

- [4.12 - Lab 13](#412---lab-13)
  - [Objectives](#objectives)
  - [Deploy Prometheus](#deploy-prometheus)
  - [Configure Grafana](#configure-grafana)
  - [Deploy Grafana](#deploy-grafana)
  - [Access the Grafana Web Interface](#access-the-grafana-web-interface)

## Objectives

- Deploy Prometheus
- Configure Grafana
- Deploy Grafana
- Access the Grafana Instance

## Deploy Prometheus

1. Using the terminal, navigate to the `prometheus` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/monitoring/prometheus`

2. Copy the default configuration values file.

    `cp prometheus-data-values.yaml.example prometheus-data-values.yaml`

3. Set the kubectl context to the tkc-01 cluster.

    `kubectl config use-context tkc-01-admin@tkc-01`

4. Create a namespace for the Prometheus service on the Tanzu Kubernetes cluster.

    `kubectl apply -f namespace-role.yaml`

5. Create a Kubernetes secret from the configuration values file.

    `kubectl create secret generic prometheus-data-values --from-file=values.yaml=prometheus-data-values.yaml -n tanzu-system-monitoring`

6. Deploy the Prometheus extension.

    `kubectl apply -f prometheus-extension.yaml`

7. Verify the status of the deployment by using kubectl.

    `kubectl get app prometheus -n tanzu-system-monitoring`

    Re-run the command until the status displays as `Reconcile succeeded`.

8. Verify the status of the deployment by using kapp.

    `kapp list -n tanzu-system-monitoring`

    `kapp inspect --app prometheus-ctrl -n tanzu-system-monitoring`

## Configure Grafana

1. Using the terminal, navigate to the `grafana` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/monitoring/grafana`

2. Copy the default configuration values file.

    `cp grafana-data-values.yaml.example grafana-data-values.yaml`

3. Create a base64 encoded password.

    `echo -n "VMware1!" | base64`

4. Open `grafana-data-values.yaml` in Visual Studio Code.

    `code grafana-data-values.yaml`

    1. Modify the following parameters.

        The configuration file should resemble the following screenshot.

    2. Save the file and close Visual Studio Code.
5. Verify that the configuration file matches the reference configuration file.

    `checkconfig grafana-data-values.yaml`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.

## Deploy Grafana

1. Using the terminal, navigate to the `grafana` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/monitoring/grafana`

2. Create the namespaces.

    `kubectl apply -f namespace-role.yaml`

3. Create a Kubernetes secret with the configuration values file.

    `kubectl create secret generic grafana-data-values --from-file=values.yaml=grafana-data-values.yaml -n tanzu-system-monitoring`

4. Deploy the Grafana extension.

    `kubectl apply -f grafana-extension.yaml`

5. Verify the status of the deployment by using kubectl.

    `kubectl get app grafana -n tanzu-system-monitoring`

    Re-run the command until the status displays as `Reconcile succeeded`.

6. Verify the status of the deployment by using kapp.

    `kapp list -n tanzu-system-monitoring`

    `kapp inspect --app grafana-ctrl -n tanzu-system-monitoring`

## Access the Grafana Web Interface

1. Using Firefox, open the Grafana bookmark in a new tab.

    `https://grafana.tkg.vclass.local`

2. Click **Advanced** and click **Accept the Risk and Continue**.

    The browser redirects to the Grafana login screen.

3. Log in to Grafana.
    - User name: admin
    - Password: VMware1!
4. In the left navigation panel, click **+** and click **Import**.
5. On the Import screen, enter 7249 for **Import via grafana.com**.

    7249 is the ID of a freely available Kubernetes dashboard on Grafana.com

6. Click **Load**.

    The dashboard information displays.

7. For Prometheus, select **Prometheus**.
8. Click **Import**.

    The imported dashboard displays.
