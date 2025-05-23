# 4.10 - Lab 12

## Objectives

- Retrieve the secret key for DNS updates
- Configure external DNS
- Deploy External DNS

## Retrieve the Secret Key For DNS Updates

1. In the terminal, display the BIND configuration.

    `cat /etc/bind/named.conf.local`

    In this lab, the student desktop is performing the role of DNS server.

2. Under externaldns-key, copy the value of `secret` and paste it in to `commands.txt` on the desktop.

## Configure External DNS

1. Using the terminal, navigate to the `external-dns` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/service-discovery/external-dns`

2. Copy the sample configuration file.

    `cp external-dns-data-values-rfc2136-with-contour.yaml.example external-dns-data-values.yaml`

3. Open `external-dns-data-values.yaml` in Visual Studio Code.

    `code external-dns-data-values.yaml`

    1. Modify the following parameters.
    2. Save the file and close Visual Studio Code.
4. Verify that the configuration file matches the reference configuration file.

    `checkconfig external-dns-data-values.yaml`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.

## Deploy External DNS

    1. Using the terminal, navigate to the `external-dns` directory.

        `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1/extensions/service-discovery/external-dns`

    2. Set the kubectl context to the tkc-01 cluster.

        `kubectl config use-context tkc-01-admin@tkc-01`

    3. Create the namespace and roles.

        `kubectl apply -f namespace-role.yaml`

    4. Create a secret containing the External DNS configuration.

        `kubectl create secret generic external-dns-data-values --from-file=values.yaml=external-dns-data-values.yaml -n tanzu-system-service-discovery`

    5. Deploy External DNS.

        `kubectl apply -f external-dns-extension.yaml`

    6. Verify the status of the deployment by using kubectl.

        `kubectl get app external-dns -n tanzu-system-service-discovery`

        Re-run the command until the status displays as `Reconcile succeeded`.

    7. Verify the status of the deployment by using kapp.

        `kapp list -n tanzu-system-service-discovery`

        `kapp inspect --app external-dns-ctrl -n tanzu-system-service-discovery`
