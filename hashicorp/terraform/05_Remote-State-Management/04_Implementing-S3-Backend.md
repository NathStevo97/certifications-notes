# 5.4 - Implementing S3 Backend

- Terraform has multiple backends supported for remote storage.
- For AWS, the standard practice is to use an S3 bucket.
- Unless a remote backend is specified, the TFstate file will be stored locally by default.

- Remote backends can be implemented in a similar format to:

```go
terraform {
    backend "s3" {
        bucket = "bucket name"
        key    = "tfstate_filename.tfstate"
        region = "<region>"
    }
}

```

- **Note:** The bucket has to be created manually in AWS prior to remote state creation.
