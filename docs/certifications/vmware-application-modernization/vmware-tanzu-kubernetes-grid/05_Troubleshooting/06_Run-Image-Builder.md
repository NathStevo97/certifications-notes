# 5.6 - Lab 17

## Objectives

- Unzip the Tanzu Kubernetes Grid Image Builder Files
- Load the OVF tool into the Image Builder Container Image
- Prepare the Image Builder Configuration
- Run Image Builder

## Unzip the Tanzu Kubernetes Grid Image Builder Files

1. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads`

2. Unzip the Tanzu Kubernetes Grid Image Builder file.

    `unzip TKG-Image-Builder-for-Kubernetes-v1.19.9-master.zip`

3. Move the files to the `imagebuilder` directory.

    `mv TKG-Image-Builder-for-Kubernetes-v1.19.9-master/TKG-Image-Builder-for-Kubernetes-v1.19.9/ ~/Workspace/imagebuilder`

4. List the directory contents to verify that the files were copied.

    `ls -l ~/Workspace/imagebuilder/TKG-Image-Builder-for-Kubernetes-v1.19.9`

## Load the OVF tool into the Image Builder Container Image

1. Using the terminal, navigate to the imagebuilder directory.

    `cd ~/Workspace/imagebuilder`

2. Copy the OVF Tool file from the `Downloads` directory.

    `cp ~/Downloads/VMware-ovftool-4.4.1-16812187-lin.x86_64.bundle ./`

3. Open `Dockerfile` in Visual Studio Code.

    `code Dockerfile`

    1. Modify the following parameter.
    2. Save the file and close Visual Studio Code.
4. Verify that the configuration file matches the reference configuration file.

    `checkconfig Dockerfile`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.
5. Build the container image.

    `docker build . -t harbor.vclass.local/tkg/imagebuilder-byoi:v0.1.9`

## Prepare the Image Builder Configuration

1. Using the terminal, navigate to the `imagebuilder` directory.

    `cd ~/Workspace/imagebuilder`

2. Open `custom.json` in Visual Studio Code.

    `code custom.json`

    1. Modify `custom.json` by adding libnfs-utils to the **extra_debs** field.

        `"extra_debs": "\"libnfs-utils\""`

        The field must be double-quoted.

        The libnfs-utils package will be installed in the image.

    2. Save the file and close Visual Studio Code.
3. Verify that the configuration file matches the reference configuration file.

    `checkconfig custom.json`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.
4. Open `metadata.json` in Visual Studio Code.

    `code metadata.json`

    1. Modify `metadata.json` by appending vclass.0 to the **VERSION** field.

        `"VERSION": "v1.19.9+vmware.2-vclass.0"`

        This distinguishes the custom image version from the default TKG v1.19.9+vmware.2 version.

    2. Save the file and close Visual Studio Code.
5. Verify that the configuration file matches the reference configuration file.

    `checkconfig metadata.json`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.
6. Open `vsphere.json` in Visual Studio Code.

    `code vsphere.json`

    1. Modify `vsphere.json` with the following vSphere environment details.
    2. Save the file and close Visual Studio Code.
7. Verify that the configuration file matches the reference configuration file.

    `checkconfig vsphere.json`

    When a configuration mismatch exists, Visual Studio Code opens the configuration file in the left panel and the reference configuration file in the right panel.

    1. If a configuration mismatch exists, modify the configuration on the left to match the reference configuration on the right.

        Differences are highlighted in red.

    2. Save the file and close Visual Studio Code.

## Run Image Builder

1. Using the terminal, navigate to the `imagebuilder` directory.

    `cd ~/Workspace/imagebuilder`

2. Review the build script.

    `cat build.sh`

    This script passes all the configuration files as parameters to the image builder container image.

    The `build-node-ova-vsphere-ubuntu-2004` command runs inside the container.

3. Run the build script.

    `./build.sh`

    The build process will take approximately 20 minutes to complete.

    The generated OVA file is saved to the `output` directory.

4. List the generated OVA files.

    `ls -l output/ubuntu-2004-kube-v1.19.9`

    The OVA files display.
