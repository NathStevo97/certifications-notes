# 5.6 - Integrating DynamoDB with S3 for State Locking

- To implement state locking on a TFState file stored in an S3 bucket, one can utilize a DynamoDB table.
- This DB, like the S3 bucket for remote stage storage, must be created manually.
- Once created, it can be referenced in Terraform in  a similar manner to the following:

```go
resource "aws_dynamodb_table" "terraform_state_lock" { 
    name = "terraform-lock"
    read_capacity = 5
    write_capacity = 5
    hash_key = "LockID" 
    attribute {
    name = "LockID"
    type = "S"
    }
}
```
