# 6.3 - Handling Multiple AWS Profiles with Providers

- When considering resource deployment to multiple accounts, in particular with AWS, one must consider the credentials file at `~/.aws/credentials`
- This file can store credentials for multiple accounts, in a format similar to:

```shell
[account01]
aws_access_key_id = ACCESS_KEY
aws_secret_access_key = SECRET_KEY

[account02]
aws_access_key_id = ACCESS_KEY
aws_secret_access_key = SECRET_KEY
```

- To utilise the credentials from a specific account, in the desired provider, add `profile = "<account name>"`
