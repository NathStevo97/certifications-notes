# 4.3 - Variable Types

## String

- Sequences of characters that can be defined in a playbook, inventory, or as CLI arguments.
- **Example:** `username: "admin"`

## Number

- Integer or floating-point values. May be set as standalone values or used in mathematical operations.
- **Example:** `max_connections: 100`

## Boolean

- True or False, typically used in conditionals.
- **Example:** `debug_mode: true`
- True/False are not the only accepted values for `True` or `False` to be registered:
  - `Truthy` Values: True, 'true', 't', 'yes', 'y', 'on', '1', 1, 1.0
  - `Falsy` Values: False, 'false', 'f', 'no', 'n', 'off', '0', 0, 0.0

## List

- Used to hold an ordered collection of values, the values must all be of the same type, but any value type is supported by lists themselves
- Example:

```shell
packages:
- nginx
- git
- terraform
...
```

- Specific list values can be referred to via `{{ <list name>[item index] }}`
  - **Note:** The first element is always index `0`.
- Lists themselves can then be referred to via loops - refer to section 5.7 for further details.

## Dictionary

- Holds a collection of key-value pairs.
- Keys and values can be any values.

```yaml
user:
  name: "admin"
  password: "secret"
```

- Dictionary values can be referred to via `{{ <dictionary name>.<key name> }}`
