# 2.0 - Adding Configuration, Secrets, and Multi-Platform Functionality

## Provisioners

- Provisioners are typically used to help configure Packer images to particular needs.
  - This is typically achieved by allowing files to be used, or:
    - Running configuration management tools (Ansible, Chef, etc)
    - Scripts (Powershell, Bash, etc.) on the image being built or the local system
    - Manage any files to be used by or extracted from the image being built

## Provisioners - File

- Used to upload assets, config files, etc. to the image.
- Full directories can be uploaded / downloaded, files included.
- Multiple connector methods available to support this.
- **Note:**
  - The "Packer User" does not have root privileges, it is advised to move any files to a temporary directory before further manipulation in the image, the latter set of operations can be achieved by a script.
  - This provisioner cannot change the permissions of the files, a script(s) should be used for this.

### Example

```go
source "amazon-ebs" "build" {
    ssh_username = "ubuntu"
    ami_name = "globoticket-${uuidv4()}"
    source_ami = "<ami id>"
    instance_type = "t3.micro"
}

build {
    sources = ["source.amazon-ebs"]

    provisioner "file" {
        source = "config/nginx.service"
        destination = "/tmp/"
    }

    provisioner "file" {
        source = "config/nginx.conf"
        destination = "/tmp/"
    }

    provisioner "file" {
        source = "assets"
        destination = "/tmp/"
    }
}
```

## Provisioners - Script

- Allows running of any scripts used to run programs on the image or local system, with many options available for differing OS. Examples include:
  - Local Shell
    - Run scripts on the local machine, typically used for "prerequisite" actions for other provisioners.
  - Remote Shell
    - Typically used with Linux machines - runs commands on image.
  - Powershell
    - Like remote shell, but used to run Powershell scripts.
  - Windows Shell
    - Used for bash scripts.
  - Windows Restart
    - Causes packer to reboot the VM without losing connectivity.

- **Note:** When running scripts like this in automation, add the `-x` flag to the shebang, which outputs the commands being ran in standard output.

- Example usage, adding beyond the "file" provisioners previously.

```go
build {
    ...
    provisioner "shell" {
        execute_command = "sudo -S env {{.Vars }} {{ .Path }}"
        inline = [
            "mkdir -p /var/globoticket",
            "mv /tmp/nginx.conf /var/globoticket/",
            "mv /tmp/nginx.service /etc/systemd/system/nginx.service",
            "mv /tmp/assets /var/globoticket"
        ]
    }

    provisioner "shell" {
        execute_command = "sudo -S env {{.Vars }} {{ .Path }}"
        script = "scripts/build_nginx_webapp.sh"
    }
    ...
}
```

- In the example above: `execute_command` acts as a prerequisite command to enable the image to run the scripts specified.
- The substitutions in `{{ }}` are substitutions.
  - `.Vars` contains all environment variables needed to pass the command (and any specified as part of the provisioner)
  - `.Path` contains the path to the script Packer will be running, auto-populated.
- `Inline` allows each command to be listed as an array, separated by commas. This is ok for simple operations, but scripts are better for usage.
- When using the `script` parameter, Packer looks to the directory defined, which must be relative to the directory that Packer is being run from (or specify a full path (not recommended)).

## Data Sources

- Data sources are sources of information that can be referenced by Packer to obtain information to be used in image builds. A common example of this is looking up base AMIs in AWS, or looking up secrets manager

```go
data "amazon-ami" "globoticket" {
    filters = {
        virtualization_type = "hvm"
        name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
        root_device_type = "ebs"
    }
    owners = ["<numeric id>"]
    most_recent = true
}

# Reference the data
source_ami = data.amazon-ami.globoticket.id

data "amazon-secretsmanager" "globoticket-live" {
    name = "Globoticket-live"
    key = "SECRET_ARTIST_NAME"
}

# Reference the secret in `environment`

provisioner "shell" {
    ...
    environment_vars = ["SECRET_ARTIST_NAME=${data.amazon-secretsmanager.globoticket.value}"]
    ...
}
```


## Multi-Provider Builds

- Packer can allow simultaneous generation of images on different providers, such as:
  - VMWare
  - Virtualbox
  - GCP
  - Docker

- There are caveats to this:
  - Some sources are more complex than others
  - Host limitations may become apparent -> may need to run one at a time
  - Outputs can become complex if not managed properly

- For certain providers, you may wish to install provider-specific utilities. Like VMware guest additions.
  - This can be achieved by using another provisioner, and using the `only` parameter to specify it should only run against the specific build

```go
    provisioner "shell" {
        execute_command = "sudo -S env {{.Vars }} {{ .Path }}"
        script = "scripts/virtualbox.sh"
        only = ["virtualbox-iso.globoticket]
    }
```

- Unless specified, packer will build all sources in parallel, to specify, use the `-only` flag on the CLI: `packer build -only 'type.name' template.pkr.hcl`

## Post-Processors

- Commone examples:
  - Compress
  - Import to Cloud
  - Generate image checksum
  - Generate Manifest
  - Create a Vagrant Box

- For vagrant, one may need to ensure Vagrant is installed to allow the box to be created, steps on this are provided in the documentation.
  - If wanting to keep the input artifact, set `keep_input_artifact=true` in the post_processor block.