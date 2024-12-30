# 3.06 - Entities and Aliases

- [3.06 - Entities and Aliases](#306---entities-and-aliases)
  - [Authentication for Multiple Users](#authentication-for-multiple-users)
  - [The Identity Secret Engine](#the-identity-secret-engine)

## Authentication for Multiple Users

- Vault supports multiple authentication methods, as well as allowing the same type of authentication method for different mount paths.
- Each Vault client may have multiple accounts with various identity providers and are enabled on the Vault server.
  - For example, a user may have an account each in Active Directory and GitHub
  - Rather than have policies set up for each of these, they can be collated by usage of an entity and aliases.
- The aliases can be mapped to the particular entity as entity entries.
- Policies can now be set at entity level AND per account.
  - Policies can be set to be inherited from entity level - any account added to the entity as an entity member will automatically have the particular policy applied.
- To create an entity: Access → Entities
  - ENSURE A SUFFICIENT USER AUTH METHOD IS ENABLED
  - Entities → Create Entity
    - If there are any policies already existing, add them to the entity.
      - It may be advisable to have a policy per user account.
    - Select create
- Add Aliases:
  - entities → create alias
    - Provide alias name and auth backend per alias/entry
- To test:
  - `vault login -method=userpass username=bob password=password`
    - Entity policy, alias policy should be viewable under policies
    - Under identity_policies, the entity policy should be listed
  - `vault login -method=userpass username=bsmith password=password`
    - The entity policy should still be listed under identity_policies, however the policies list should be specific to the account/alias.

## The Identity Secret Engine

- This maintains the clients recognised by Vault
- Each client is internally termed as an entity, which can have multiple aliases
- This engine is mounted by default, and cannot be disabled or moved.
