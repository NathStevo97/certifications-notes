# 3.2 - Provisioner Types

- There are 2 main types of provisioner:
  - **Local-Exec:**
    - Allows invocation of local executables after the resource is created
    - Commands defined run on the machine where terraform's being run on e.g. "runner VM", local machine, etc.
  - **Remote-Exec:**
    - Commands executed directly on the remote machine / resource.
    - Connection made typically via SSH, defined in Terraform code.
