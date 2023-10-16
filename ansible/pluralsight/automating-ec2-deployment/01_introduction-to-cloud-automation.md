# 1.0 - About AWS EC2 and Ansible Automation

- Cloud deployments have many benefits, including:
  - Rapid scalability
  - Deployment of fault-tolerant and highly available solutions
- To leverage these benefits, one can use tools like Terraform and Ansible to rapidly deploy and configure servers
- Typically provisioning is left to Terraform and configuration is done via Ansible, but Ansible can do both.

- Provisioning via Ansible ensures fast, repeatable, compliant, and automatic deployment of systems, and can make it easier to apply updates and improvements quickly.

- By automating deployments, one can reduce errors when:
  - Deploying to different regions
  - deploying version upgrades
  - there is a long pause between deployments

- Defining automation via ansible also reduced human error.

- Ansible offers many modules to dynamically provision workloads. In the following notes, tasks covered include:
  - Preparing AWS EC2 account and credentials
  - Automatically provision VPC (Virtual Private Cloud) networking
  - Provisioning and deprovisioning cloud instances with Ansible
  - Finding and selecting AMI images
  - Dynamically adding EC2 instances to the Ansible inventory for further configuration and management tasks to be applied.
