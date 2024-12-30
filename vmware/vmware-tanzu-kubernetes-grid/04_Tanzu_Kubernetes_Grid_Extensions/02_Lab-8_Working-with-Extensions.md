# 4.02 - Lab 8

- [4.02 - Lab 8](#402---lab-8)
  - [Objectives](#objectives)
  - [Unzip the TKG Extensions](#unzip-the-tkg-extensions)
  - [Change the Image Registry Location](#change-the-image-registry-location)

## Objectives

- Unzip the TKG extensions
- Change the image registry location

## Unzip the TKG Extensions

1. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads/`

2. Unzip the **tkg-extensions** file to the `Workspace` directory.

    `tar -zxvf tkg-extensions-manifests-v1.3.1-vmware.1.tar.gz -C ~/Workspace/`

3. Navigate to the `Workspace` directory.

    `cd ~/Workspace/tkg-extensions-v1.3.1+vmware.1`

4. List the files.

    `tree -d -L 2 | less`

    Because the `extensions` subdirectory contains the main configuration that you edit before deploying each extension, you will mostly work out of this directory.

    The other directories contain the kapp and ytt templates for overriding advanced parameters for each extension.

## Change the Image Registry Location

1. Using the terminal, navigate to the `Workspace` directory.

    `cd ~/Workspace`

2. Run the script to update the extension files to load images from Harbor.

    `./tkg-ext-to-harbor.sh`

    The extensions manifest files point to Harbor.
