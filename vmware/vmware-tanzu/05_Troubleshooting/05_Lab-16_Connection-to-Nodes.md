# 5.5 - Lab 16

Tags: Done

# Objective

- Connect to a Node using SSH

# Connect to a Node Using SSH

1. Using the terminal, set the kubectl context to the tkc-01 cluster.

    `kubectl config use-context tkc-01-admin@tkc-01`

2. List the nodes in the tkc-01 cluster.

    `kubectl get nodes -o wide`

3. Copy the IP address of the control plane node.
4. Connect with SSH by using the capv user.

    `ssh capv@<CONTROL_PLANE_IP_ADDRESS>`

    The SSH connection succeeds without a password because the ~/.ssh/id_rsa.pub public key from the student desktop was added to each Kubernetes node.

5. Change to the root user.

    `sudo -i`

6. Navigate to the `log` directory.

    `cd /var/log/containers`

7. List the logs.

    `ls -l`

    The directory contains logs for the running containers.

8. Navigate to the `kubernetes` directory.

    `cd /var/log/kubernetes`

9. List the logs.

    `ls -l`

    The directory contains audit logs for Kubernetes API server.

10. Enter `exit` to close the root session and enter `exit` to close the SSH connection.
