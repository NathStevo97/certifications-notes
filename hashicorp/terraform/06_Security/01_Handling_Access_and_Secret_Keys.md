# 6.1 - Handling Access and Secret Keys

- Any credentials should NEVER be stored in a `.tf` file or associated project. 
- They should always be stored as secrets or environment variables.
- For AWS, this could be achieved by running `aws configure` upon downloading the AWS CLI.
    - Similar operations available for Azure and GCP e.g. `azure login`