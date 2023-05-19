# 2.0 - Planning and Preparing for Automation

## 2.1 - Planning for the EC2 Deployment

- Prior to any deployment, one should always design and plan the resources / architecture required.
- If deploying to the cloud, there's always guidance provided.

### AWS Terminology:

  - VMs in AWS = Instances
  - Instance types define the resource capacity of the instance e.g. memory, cpu, etc.
  - Amazon Machine Image (AMIs) provide templates for the base OS and configuration
  - Virtual Private Cloud = Virtual Network - Isolated from AWS Cloud
  - Security Groups control firewall rules for the instances and associated resources
  - Tags = Metadata used to label resources.

### Deployment Process Overview:

- Create a network:
  - VPC
  - Internet Gateway
  - Public Subnet
  - Routing Table
  - Security Group

- Create a RHEL 8 EC2 Instance
  - Find the RHEL 8 AMI needed
  - Create an SSH key for provisioning
  - Launch the instance using the AMI

- Save the EC2 Instance as an Image (if desired)
- Tear down the EC2 instances

### Planning the Deployment

- Questions to answer include:
  - How's the network setup?
  - How many instances are needed, what type?
  - Can standard AMIs be used? Or do they need to be customized?
  - Resource requirements?
  - Users, passwords, keys, etc needed for access to the deployment?

## 2.2 - Preparing the Ansible Control Node

### Preparing the Control Node

- Can be any Linux machine with Python 2 or 3 installed
- Recommended to keep it outside of AWS to provision everything.
- Just needs Ansible to be installed.

- On a RHEL or CentOS-based system, you're advised to install via `pip`, the package manager for Python:
  1. Install pip: `sudo yum install python3-pip`
  1. Install Ansible 2.9 and AWS module dependencies: `sudo pip3 install ansible boto boto3`

- For AWS, ensure that a specific IAM user has been created for Ansible's usage - allowing you to limit the access Ansible has to the account.
  - Ensure Access Key and Secret Key are saved, and the user has programmatic access.
  - Recommended actions: 
    - Add user to a group and give permissions for EC2 and VPC "Full Access" only (principle of least privilege)
    - Add tags for further ease of identification.

- It's recommended to prepare a variables file to store certain values to facilitate the Ansible Plays, unless these are sensitive, store them in a standard `yaml` vars file.
  - If sensitive data, store as an environment variable or as an encrypted value in ansible-vault. This can be applied to a full variable file via `ansible-vault encrypt vars/info.yaml`

- Sample vars suggested for the play(s):
  - `aws_id` (Access key)
  - `aws_key` (Secret key)
  - `aws_region`
  - `ssh_keyname`
  - `remote_user` (IAM user)