# 6.5 - The Sensitive Parameter

- When managing large sets of infrastructure in Terraform, it's highly likely it will involve the use of sensitive information such as credentials.
- This should never be output directly in plaintext for security reasons.
- To avoid, use the `sensitive` parameter, refer to the following example:

```go
output "db_password" {
    value = aws_db_instance.db.password
    description = "Password for Database Login"
    sensitive = true
}
```

- Setting the sensitive parameter to true prevents it being output in the CLI, but it will still be stored in the state, so it's better to utilise a secrets manager for this.
