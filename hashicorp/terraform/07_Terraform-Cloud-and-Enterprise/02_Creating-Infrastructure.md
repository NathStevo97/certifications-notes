# 7.2 - Creating Infrastructure with Terraform Cloud

- Pricing for Terraform Cloud depends on the user's requirements.
  - For teams and governance, more features would be required compared to a personal user.
  - TO create an account, review the following [link](https://app.terraform.io/signup/account)
- When getting started, you must first create an organization and a workspace.
  - Then link a version control tool e.g. Github.
  - Providers may need to be added - achievable via `Settings -> VCS Providers`

- For Github, the following needs to be added:
  - An optional display name for the VCS provider.
  - Client ID
  - Client Secret

- For the latter two, setup on Github is required:
  - In a repository of choice: `settings -> developer settings -> oauth applications`
  - Register the oauth application, detailing parameters such as:
    - Homepage URL (refer to Terraform Documentation)
    - Template Callback URL
  - The above step will present the client ID and secret to be added in Terraform Cloud's VCS Provider setup.
  - Add the Client parameters to the Terraform Cloud setup generates the Callback URL -> add this to the Github application.

- To create infrastructure with Terraform Cloud, add/commit any sets of files to the Github repository, then create a Workspace in Terraform Cloud.
  - When creating the workspace, connect the chosen VCS provider, and select the desired repository.

- Once configuration is complete, Terraform-related variables and environment variables must be configured, this can include AWS access keys, defaults, etc.
- Queue a plan - Initiating a `terraform plan` invocation using the code in the linked repository
- If the plan is successful, the `terraform apply` command can be invoked, or a comment can be added alongside in the event of failure.

- Terraform state file is stored on Terraform Cloud by default in this scenario for plan, apply and destroy operations.
- For production environments or plans, cost estimation for running projects and applying configurations can be obtained.