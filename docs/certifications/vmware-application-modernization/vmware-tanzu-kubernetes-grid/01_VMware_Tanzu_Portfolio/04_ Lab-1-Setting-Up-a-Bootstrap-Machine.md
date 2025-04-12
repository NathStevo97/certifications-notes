# 1.4 - Lab 1 - Setting Up a Bootstrap Machine

## Verify the Installation of Docker

- `sudo systemctl status docker` - Output should be `Active (running)`
- Run a docker command e.g. `docker ps`

## Install Kubectl CLI

- Donwload kubectl from the appropriate source
- Unzip: `gunzip <kubectl zip file>`
- Install to `/bin` directory: `sudo install kubectl-linux-v1.20.5-vmware.1 /usr/local/bin/kubectl`
- Verify installation: `kubectl version --short --client=true`

## Enable Kubernetes AutoComplete

1. Run the following command to insert the Kubernetes CLI autocompletion data into the .bash_profile file.

    `echo 'source <(kubectl completion bash)' >> ~/.bash_profile`

    Autocompletion will be enabled when a new terminal is opened.

2. Close the terminal window.
3. Reopen the terminal window.
4. Enter the `kubectl` command and press the Tab key twice.

    `kubectl`

    The autocompletion displays the available kubectl options.

    Use the Tab Tab keystroke sequence, in future labs, to reduce the amount of commands that you need to enter.

## Install the Tanzu CLI

1. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads`

2. Unzip the tanzu CLI.

    `tar -xvf tanzu-cli-bundle-v1.3.1-linux-amd64.tar`

3. Install the Tanzu CLI to the `Bin` directory.

    `sudo install cli/core/v1.3.1/tanzu-core-linux_amd64 /usr/local/bin/tanzu`

4. Display the Tanzu CLI version to ensure that the installation was successful.

    `tanzu version`

    The output displays the version number.

## Install the Tanzu CLI Plugins

1. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads`

2. Display the installed plug-ins.

    `tanzu plugin list`

    The STATUS column displays `not installed`.

3. Install the Tanzu CLI plug-in from a local `CLI` subdirectory.

    `tanzu plugin install all --local cli`

4. Display the installed plug-ins.

    `tanzu plugin list`

    The STATUS column for each plug-in, except for alpha, displays `installed`.

5. Run the Tanzu CLI to view the new options.

    `tanzu --help`

    The cluster, kubernetes-release, management-cluster, and login commands display.

## Enable Tanzu CLI Autocomplete

1. Run the following command to insert the Tanzu CLI autocompletion data into the .bash_profile file.

    `echo 'source <(tanzu completion bash)' >> ~/.bash_profile`

    Autocompletion will be enabled when a new terminal is opened.

2. Close the terminal window.
3. Reopen the terminal window.
4. Enter the `tanzu` command and then press the Tab key twice.

    `tanzu`

    Autocompletion displays the available `tanzu` options.

    Use the Tab Tab keystroke sequence in future labs to reduce the amount of commands that you need to enter.

## Install the Carvel Tools

1. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads`

2. List the tools.

    `ls -l cli/*.gz`

    Tools imgpkg, kapp, kbld, vendir, and ytt display.

3. Run the following script to unzip and install the tools.

    `./install-carvel.sh`

    The version of each tool displays.

4. Using the terminal, navigate to the `Downloads` directory.

    `cd ~/Downloads`

5. List the tools.

    `ls -l cli/*.gz`

    Tools imgpkg, kapp, kbld, vendir, and ytt display.

6. Run the following script to unzip and install the tools.

    `./install-carvel.sh`

    The version of each tool displays.
