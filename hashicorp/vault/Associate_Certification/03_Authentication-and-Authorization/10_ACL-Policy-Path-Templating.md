# 3.10 - ACL Policy Path Templating

- [3.10 - ACL Policy Path Templating](#310---acl-policy-path-templating)
  - [Contexts](#contexts)
  - [Path Templating Overview](#path-templating-overview)
  - [Practical Example](#practical-example)
  - [Supported Parameters](#supported-parameters)

## Contexts

- Consider `/secret` has two prefixes for two users:
  - `/alice`
  - `/bob`
- Each user should only be able to view what is available to them at their particular path i.e. a policy would be required for each:

```go
path "secret/data/alice/" {
 capabilities = ["create", "update", "delete"]
}

path "secret/data/bob/" {
 capabilities = ["create", "update", "delete"]
}
```

- For two users only, this is easy to manage, however if there are hundreds of users it will be pointless to write effectively the same policy over and over.
- Path Templating can be used to help here.

## Path Templating Overview

- Path templating allows variable replacement based on information provided by the entity associated.

```go
path "secret/data/{{identity.entity.name}}/*" {
 capabilities = ["create", "update", "delete"]
}
```

- So suppose this policy is assigned to an entity which the `alice` and `bob` users are part of, `{{identity.entity.name}}` would be replaced by `alice` or `bob`.

## Practical Example

1. Generate a sample policy to `"secret/data/{{identity.entity.name}}/*`
    1. Add `secret/metadata` as well if desired
2. Create a sample user set e.g. Alice and Bob via the desired authentication method (use userpass for ease)
3. Create an entity for each user and attach the template policy from step 1 to each, then attach the user alias
4. Verify the configuration via `vault login` for each of the users.
5. Test the capabilities for each user by creating a new secret at `/secret/....`
    1. Alice-user should only be able to review secrets under `/alice` and not `/bob` and vice versa
6. This will be applicable for any additional users created in this manner.

## Supported Parameters

| Name | Description |
| --- | --- |
| `identity.entity.id` | Entity ID |
| `identity.entity.name` | Entity Name |
| `identity.entity.metadata.<metadata-key>` | Metadata associated with an entity for a given key |
| `identity.entity.aliases.<mount-accessor>.id` | Entity alias ID for a particular mount |
| `identity.entity.aliases.<mount-accessor>.name` | Entity alias name for particular mount |
| `identity.entity.aliases.<mount-accessor>.metadata.<metadada-key>` | Metadata associated with an alias for a given mount and metadata key |
| `identity.groups.ids.<groupid>.name` | Group name for a particular group ID |
| `identity.groups.names.<group name>.id` | Group ID for a particular group name |
| `identity.groups.ids.<group id>.metadata.<metadata key>` | Metadata associated with a particular group id for a particular metadata key |
| `identity.groups.names.<group name>.metadata.<metadata key>` | Metadata associated with a particular group name for a particular metadata key |
