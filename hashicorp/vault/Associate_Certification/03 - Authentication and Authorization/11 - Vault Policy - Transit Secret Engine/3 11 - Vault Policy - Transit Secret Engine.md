# 3.11 - Vault Policy - Transit Secret Engine

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Vault Policy Rules - Transit Engine

- For Vault clients to be able to perform encryption and decryption operations, two policy rules are required:

```go
path "transit/encrypt/<key_name>" {
  capabilities = ["update"]
}

path "transit/decrypt/<key_name>" {
  capabilities = ["update"]
}
```

## Practical Demo

- Enable the transit secret engine
- Create an example encryption key
- Enable a suitable authentication method for a new user (create if required)
- Sign in to the Vault UI via the assigned method
  - Note that based on the default policy, the user can't do much
- Via admin,  create a policy with the rules above and associate it with the sample user.
- Upon signing out and signing in, the sample user should now see the transit/ secret path
  - The secrets won't be listable however, add a rule with the `list` capability to the path `transit/keys`
- Still not done..... add another rule with the `read` capability to the path `/transit/keys/<key-name>`
