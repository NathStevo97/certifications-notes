# 2.3 - Lab 3

Tags: Done

# Objectives

1. Log in to the vSphere Client
2. Create Resource Pools
3. Create a VM Folder
4. Import the Base OS Template OVA Files
5. Convert the VMs to Templates

# Login to the vSphere Client

1. Using Firefox, open the vSphere Client bookmark in a new tab.
2. Log in to the vSphere Client.
    - User name: <administrator@vsphere.local>
    - Password: VMware1!
3. Expand **SA-Datacenter** and expand **SA-Cluster-01**.
4. Verify that nsx-adv-lb-controller is powered on.
    1. If nsx-adv-lb-controller is not powered on, right-click **nsx-adv-lb-controller** and select **Power** > **Power On**.

# Create the Resource Pools

You create resource pools for the management cluster and workload clusters.

1. In the vSphere Client, click **Menu**.
2. Click **Hosts and Clusters**.
3. In the navigation pane, expand **SA-Datacenter**.
4. Right-click **SA-Cluster-01**.
5. Click **New Resource Pool**.
6. Enter rp-tkg-management in the **Name** text box and click **OK**.
7. Right-click **SA-Cluster-01**.
8. Click **New Resource Pool**.
9. Enter rp-tkg-production in the **Name** text box and click **OK**.

# Create a VM Folder

You create a VM folder to place VMs created by Tanzu Kubernetes Grid.

1. In the vSphere Client, click **Menu**.
2. Click **VMs and Templates**.
3. In the navigation pane, right-click **SA-Datacenter**.
4. Select **New Folder > New VM and Template Folder**.
5. In the New Folder window, enter tkg-vms in the **Enter a name for the folder** text box and click **OK**.

# Import the Base OS Template OVA Files

1. In the vSphere Client, click **Menu**.
2. Click **Hosts and Clusters**.
3. In the navigation pane, expand **SA-Datacenter**.
4. Right-click **SA-Cluster-01**.
5. Click **Deploy OVF Template**.
6. In the Deploy OVF Template window, select **Local file > UPLOAD FILES** under Select an OVF template.
7. In the Open window, select **Downloads**.
8. Select **ubuntu-2004-kube-v1.20.5-vmware.1-tkg.1-16555584836258482890.ova** and click **Open**.
9. In the Deploy OVF Template window, click **NEXT**.
10. On the Select a name and folder form, leave the default value for the virtual machine name.
11. Select **tkg-vms** for the virtual machine location and click **NEXT**.
12. Select **SA-Cluster-01** for the compute resource and click **NEXT**.
13. On the Review details form, click **NEXT**.
14. Select **I accept all license agreements** and click **NEXT**.
15. Select **SA-Shared-01** for storage.
16. Select **Thin Provision** as the virtual disk format and click **NEXT**.

    IMPORTANT:

    Ensure that you select **Thin Provision** after selecting the storage.

17. Select **pg-SA-Production** for the destination network and click **NEXT**.
18. Click **FINISH**.

    Wait for the OVF deployment to finish before proceeding to the next task.

# Convert the VMs to Templates

1. In the vSphere Client, click **Menu**.
2. Click **VMs and Templates**.
3. Right-click **ubuntu-2004-kube-v1.20.5+vmware.1**.
4. Click **Template**.
5. Click **Convert to Template**.
6. In the Confirm Convert window, click **YES**.
