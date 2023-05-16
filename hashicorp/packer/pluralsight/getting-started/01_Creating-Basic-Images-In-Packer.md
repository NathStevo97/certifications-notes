# 1.0 - Creating Basic Images

## 1.1 - Why Packer?

- Packer facilitates the development of immutable infrastructure.
- Cats vs Cattle Analogy
  - **"Cat" Servers**:
    - Require a lot of attention and specific configuration
    - If server goes down, major problems occur.
    - Lots of configuration required to maintain it, as otherwise the workloads supported are totalled.
  - **"Cattle" Servers**:
    - Servers created to serve a specific purpose
    - If the server goes down, not as problematic, another "cattle" can just be spun up quickly to replace it with no immediate difference.

- Summary Comparison:

| Cats | Cattle |
| ---- | ----- |
| Must be kept alive at all cost | Expendable |
| Lots of manual intervention needed | Work out of the box |
| Tough to scale | Easy to scale |
| High-stress management | Low-stress |

- Other benefits to immutable infrastructure include:
  - Testable infrastructure -> As infrastructure defined as code (Iac)
  - Easily reproducible environments
  - Infrastructure becomes a "unit of deployment" - deployed alongside the workloads
  - Facilitates confidence in changes


### Why Packer?

- Packer uses images as its packaging mechanism, offering specific packages per platform
- It's cross-platform, capable of running on and creating images for Windows and Linux
- It allows utilization of existing tools to manage and rollout of infrastructure
- Easily integrates with configuration management tools, such as Ansible, Chef, and standard scripting.

---

### Packer Basics

- Packer is defined in HCL languages similar to Terraform.
- Images are built via the use of templates, which follow a standard format:

```go
source "type" "name" {

}

build {
    sources = ["source.type.name"]
    provisioner "type" {

    }

    post-processor "type" {

    }
}
```

- `Source` defines the "where" of the configuration build, defining the platform and any specific parameters for the image to be build.
- `Build` defines a unit of execution. Builds refer to 1 or more sources.
  - Within build, you define any number of `provisioners` to carry out configuration tasks for the images.
  - `Post-Processors` are used to "transform" the image after building from one form to another. The most common example for this is "Vagrant".

#### Sources

- Source blocks will always contain:
  - The type of source builder e.g. `amazon-ebs`, `vmware-iso`
  - The local name of the build.
  - Configuration parameters for thhe build:
    - Each build type contains build-specific parameters e.g.:
      - For AWS, one needs to provide an `ami_name`, whereas `vmware-iso` requires ISO information.

#### Builds

- Combine sources with provisioning/post-processing.
- Multiple sources can be included in a single build, so could output multi-platform images with one run, or just do one particular one depending on the needs.
  - This is often beneficial for say different environment builds.

#### Provisioners

- Used to customise the image
- Typically uses scripts (powershell or bash) or configuration management tools like Ansible.
- Provisioners can be configured to run only against particular sources e.g. "fetch ami name" is only applicable to AWS, there's no point running it for a virtualbox build.

#### Post-Processors

- Used to transform build outputs
- Examples include:
  - Checksum generation
  - Export to an AWS AMI or Vagrant Box
- Multiple post-processors can be used sequentially by usage of the `post_porcessors {}` block

### Common Commands:

- `packer fmt <template>.pkr.hcl` - Apply standard formatting
- `packer validate <template>.pkr.hcl` - Syntax validation of configuration
- `packer build <template>.pkr.hcl` - Build the image
  - Common options:
    - `-debug` - pause after each provisioner step and post-processor, provides the SSH key for the machine to verify build process during build.
    - `-var` - supply a variable to the build in the form `<key>=value`
    - `-only` - specify only a particular source
    - `-on-error`

---

## 1.2

- Randomness can be introduced using Packer's function: `${uuidv4()}`
