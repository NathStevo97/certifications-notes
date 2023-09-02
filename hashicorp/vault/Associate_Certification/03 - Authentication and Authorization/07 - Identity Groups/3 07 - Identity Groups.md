# 3.07 - Identity Groups

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Identity Groups

---

- Groups can contain multiple entities as members
- Policies set at group level will be applied to all members of the group i.e. all entities and the associated aliases
    - I.e. all users and all associated accounts as part of the group will have the policies be applied

## Demonstration

- Assuming a entity has already been created (refer to section 3.06), create a new policy to be applied to the team e.g. allow read capabilities to all secrets under the secret/ path
- From Access → Groups, select "Create Group"
    - Provide the group name
    - Select type (internal or external)
    - Select any policy(ies) to be associated with the group
    - Add the member group IDs or the Entity IDs to be added to the group
    - Create
- To verify, login as a user as part of the group using `vault login`
    - The group policy should be included under the key `identity_policies` AND the `policies` key

## Internal and External Groups

- By default, Vault creates an internal group
- Many organizations have groups predefined with their external identity providers, such as Active Directory
- External groups allows these providers to be linked to Vault via the `external identity` provider (auth provider) such that appropriate policies can be attached to the group