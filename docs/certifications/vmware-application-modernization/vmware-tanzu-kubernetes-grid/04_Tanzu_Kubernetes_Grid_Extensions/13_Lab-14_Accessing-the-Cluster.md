# 4.13 - Lab 14

## Objectives

1. Access the cluster as a developer
2. Deploy a workload
3. Inspect the NSX Advanced load balancer
4. Inspect the logs in vRealize log insight

## Access the Cluster as a Developer

1. Using the terminal, click the new terminal tab button in the top left.

    Keep the original terminal tab to continue accessing the cluster using the admin account.

    Use the new terminal tab to access the cluster using the developer account.

2. Navigate to the `Workspace` directory.

    `cd ~/Workspace`

3. Using the new terminal tab, make kubectl use the new kubeconfig.

    `export KUBECONFIG=~/Workspace/kubeconfig-developers.yaml`

4. Attempt access the cluster using kubectl.

    `kubectl get pods -A`

    The browser opens.

5. Click **Advanced**, then click **Accept the Risk and Continue**.

    The browser redirects to the LDAP login screen.

6. Click **Advanced**, then click **Accept the Risk and Continue**.

    The browser displays the login screen.

7. Log in using the LDAP credentials.
    - User name: developer01
    - Password: VMware1!
8. Click **Login**.

    `You have been logged in and may now close this tab` is displayed in the browser.

9. In the terminal, review the kubectl output.

    The pods running on the cluster are listed.

10. List the kubectl contexts.

    `kubectl config get-contexts`

    The `tanzu-cli-tkc-01@tkc-01` context displays.

## Developer Workload

1. Using the terminal, navigate to the `Workspace` directory.

    `cd ~/Workspace`

2. Ensure that kubectl is using the developer credentials.

    `export KUBECONFIG=~/Workspace/kubeconfig-developers.yaml`

3. Display the vmbeans configuration file.

    `cat vmbeans.yaml`

    A deployment and LoadBalancer service type display.

    The service has an external-dns annotation specifying the VMBeans FQDN.

4. Deploy the vmbeans configuration.

    `kubectl apply -f vmbeans.yaml`

5. Verify the status of the deployment by using kubectl.

    `kubectl get deployment,service`

    Re-run the command until the deployment status is READY 1/1 and the vmbeans-service has an IP address listed in the EXTERNAL-IP field.

6. Using Firefox, open the VMBeans bookmark in a new tab.

    `http://vmbeans.tkg.vclass.local`

    The VMBeans website displays.

## Inspect the NSX Advanced Load Balancer UI

1. Using Firefox, open the NSX Adv LB bookmark.

    `https://sa-nsxlb-01.vclass.local`

2. Log in to NSX Advanced Load Balancer.
    - User name: admin
    - Password: VMware1!
3. On the Dashboard screen, under Virtual Services, click **default-tkc-01--default-...**.

    default-tkc-01--default is the load balancer for the VMBeans service that you created in the previous task.

4. Click **Displaying Past 6 Hours** and change it to **Past 30 Minutes**.
5. Using the terminal, navigate to the `Workspace` directory.

    `cd ~/Workspace/`

6. Generate traffic to the VMBeans website and leave the command running.

    `./gen-vmbeans-http-req.sh`

7. View the traffic in NSX Advanced Load Balancer UI.

    It takes a few minutes for the graph to display the traffic.

    Continue to the next task while waiting for the graph to update.

## Inspect the Logs in Vrealize Log Insight

1. Using Firefox, click the vRLI bookmark in a new tab.

    `https://sa-loginsight-01.vclass.local`

2. Log in to vRealize Log Insight.
    - User name: admin
    - Password: VMware1!
3. In the top panel, click **Interactive Analytics**.
4. Click **ADD FILTER**.
5. From the **text** drop-down menu, click **appname**.
6. In the text box beside **contains**, enter vmbeans and select the full pod name **vmbeans-deployment-##########-#####**.
7. Click the search icon.

    The logs from the vmbeans pod display.

8. Review the first log entry in the list.

    The log line contains "`GET / HTTP/1.1 200`" which is a web request logged by the web server process inside the VMBeans pod.

9. Using the terminal, close the terminal tab created in task 1 so you are no longer using the `~/Workspace/kubeconfig-developers.yaml` file to access the cluster.
