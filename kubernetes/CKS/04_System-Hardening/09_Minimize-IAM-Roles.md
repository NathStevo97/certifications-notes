# 4.9 - Minimize IAM Roles

- As discussed in the section **Limit Node Access**, it's never a good idea to use the Root account to perform daily tasks, SSH hardening can prevent root access and force users to using their own user accounts.
- Root accounts are equivalent to Admin accounts in Windows and Root Accounts in public cloud platforms e.g. AWS
- **Note:** AWS used as an example for this section but topics apply
  - 1st account (Root account) created - User can log into management credentials
    - Any and all functions can be carried out by this account on the management account
  - Root account, in line with the least privilege principle, should be used to create new users and assign them the appropriate permissions
  - The credentials for the root account should be saved and secured as appropriate
- When a new user is created, the least privilege is assigned depending on the associated IAM (Identity Access Management) policy.
  - E.g. developers have ability to create EC2 instances, but can only view the S3 Buckets
  - For further ease of assignment, users could be added to particular role groups or IAM groups - an IAM policy can then be attached to the group and assigned automatically.
- For resources and services, by default, no permissions are allowed. This cannot be achieved via IAM policies, roles must be developed.
  - Allows secure access to an AWS Resource(s)
  - **Example** - Allow EC2 Instance Access to an S3 Bucket.
- **Note:** Programmatic access can be configured, but this is typically less secure than via IAM methods.
