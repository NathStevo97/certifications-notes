# 2.20 - Saving Terraform Plan to a File

- When generating a Terraform plan, it can be beneficial to save it to a particular path.
- By doing so, this plan can be viewed later or can be used toa pply changes specified only by that plan.
- To save a plan: `terraform plan -out /path/to/file`
- To apply a saved plan: `terraform apply /path/to/file`
