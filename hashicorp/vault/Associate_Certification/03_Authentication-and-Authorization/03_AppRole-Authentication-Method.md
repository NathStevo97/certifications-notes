# 3.03 - AppRole Authentication Method

## Notes

- Before a client can interact with Vault, it must authenticate against a particular auth method as outlined previously.
- Auth methods are generally targeted for one of two types of users:
  - Human users e.g. userpass
  - Machine/App users
- Once authenticated, a token is generated, which may have a policy associated.
- For machine/app users, the most common one is AppRole.
  - This allows multiple "roles" to be defined corresponding to different applications, each with different access levels e.g. one role for MySQL or a database application, another for a particular CI/CD application e.g. Jenkins.
- When authenticating via the AppRole method, applications will need to take note of:
  - Role ID
  - Secret ID

### Configuring AppRole Authentication Method

1. Create policy for role and apps
2. Get Role ID
3. Generate new Secret ID
4. Provide Role and Secret ID to application
5. Application authenticates with the provided role and secret IDs
6. Authentication token is returned.

**To enable:**

1. Enable AppRole authentication method under "access"
2. Under Policies, create a desired policy for the application e.g. allowing all non-destructive capabilities to the application
3. Create the role: `vault write /auth/approle/role/<name> token_policies="<role-name>"`
4. Test via `vault read auth/approle/role/<rolename>`
5. Read the role ID for provisioning`vault read auth/approle/role/<rolename>/role-id`
6. Generate the new secret ID: `vault write -f auth/approle/<role>/secret-id`
7. Using the IDs generated in steps 5 and 6, authenticate to vault: `vault write auth/approle/login role_id="" secret_id=""`
8. Verify the login operation is successful, a token is provisioned and the required policies are provided.

---

- The AppRole auth method is specifically designed for use by machines and applications.
- Role and Secret IDs can effectively be viewed as the application's username and passwords
