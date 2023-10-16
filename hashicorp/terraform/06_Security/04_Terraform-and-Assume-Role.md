# 6.4 - Terraform and Assume-Role with AWS STS

- When working with multiple accounts and credentials, it's advised to make use of the assume-role functionality of the AWS Security Token Service (STS).
- This is a web service that enables the request of temporary, limited-privilege credentials for AWS Identity and Access Management (IAM) users or for users that you authenticate (federated users)
- By doing so, one can keep a single set of usernames and passwords, along with authentication keys on an *identity account*. Each account underneath can then be accessed using *assume role* functionality.
- Assume-Role can be allowed for IAM roles via a policy similar to the following:

```json
{
    "Version": "YYYY-MM-DD",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam:<ID>:role/<rolename>|
        }
    ]
}
```

- To provision resources via an account with assume-role privileges:
    `aws sts assume-role --role-arn <arn url> --role-session-name <session_name>`

- Then, one needs to add particular values to the provider.tf file to specify the role being used. Within the provider block add:

```go
assume_role {
    role_arn = "<role arn>"
    session_name = "<session_name>"
}
```

- Role ARNs are resource-specific, session names can be chosen to the user's desire.