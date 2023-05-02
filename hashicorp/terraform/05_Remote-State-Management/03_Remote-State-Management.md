# 5.3 - Remote State Management

- A feature of Terraform that allows you to store tfstate files in a central repository that isn't easily accessible like Git.

- Typically, many cloud providers offer solutions for this, such as using an S3 bucket in AWS.
- Generally, Terraform supports 2 types of remote backends:
  - **Standard:** Allows state storage and locking
  - **Enhanced:** All features of standard backends, with the addition of remote management.
