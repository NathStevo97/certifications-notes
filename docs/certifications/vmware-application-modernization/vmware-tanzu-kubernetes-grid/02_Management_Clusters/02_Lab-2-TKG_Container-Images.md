# 2.2 - Lab 2

## Objectives

1. Create a Library in Harbor
2. Push Tanzu Kubernetes Grid Container Images to Harbor

## Create a Library in Harbor

1. Using Firefox, open the Harbor bookmark in a new tab.
2. Log in to Harbor.
    - User name: admin
    - Password: VMware1!
3. On the Projects page, click **NEW PROJECT**.
    1. Enter tkg for Project Name.
    2. For Access Level select **Public**.
4. Click **OK**.

## Push Tanzu Kubernetes Grid Container Images to Harbor

1. Using the terminal, navigate to the `Workspace` directory.

    `cd ~/Workspace`

2. Log in to Harbor using the docker CLI.

    `docker login harbor.vclass.local`

    - User name: admin
    - Password: VMware1!
3. Run the publish script to push container images from the student desktop to Harbor.

    `./tag-push-images.sh`

    This process will take approximately 20 minutes.

4. In Harbor, click **Projects**.
5. Click **tkg**.

    The Tanzu Kubernetes Grid container images display.
