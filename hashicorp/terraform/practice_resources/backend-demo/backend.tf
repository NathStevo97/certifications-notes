terraform {
  backend "s3" {
    bucket         = "demoremotebackend"
    key            = "remotedemo.tfstate"
    region         = "eu-west-2"
    access_key     = "AKIAIDHLXIC5PHKA4HRA"
    secret_key     = "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"
    #dynamodb_table = "s3-state-lock"
  }
}