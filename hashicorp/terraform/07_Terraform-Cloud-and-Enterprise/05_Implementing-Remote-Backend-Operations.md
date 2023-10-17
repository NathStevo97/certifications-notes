# 7.5 - Implementing Remote Backend

- Steps:
  1. Create workspace without VCS Connection
  2. Configure `backend.hcl` - detailing workspace, hostname, and organization info
  3. Configure resource configuration files with Terraform block containing `backend "remote" { .... }`
  4. Initialize the config with the backend file via `terraform init -backend-config=backend.hcl`

- For authenticaiton with a remote backend, a token is required.
  - Run `terraform login` to generate the token - the credentials are stored to a particular path upon successful execution.
  - The API token can be found on the Terraform Cloud UI, which is then copied into the user input requested.

  - Step 4 can then be re-ran if there were any issues - ensuring any required environment variables are set in the TF Cloud Workspace.
  