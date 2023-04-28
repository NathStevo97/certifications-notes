# 2.10 - Functions

- Terraform has many built-in functions that can be used to transform and combine values.
- The general syntax for a function is the function name followed by arguments separated by commas.
- User-defined functions aren't supported, but built-in function categories are:
  - Numeric
  - String
  - Collection
  - Encoding
  - Fileystem
  - Date and time
  - Hash and Crypto
  - IP Network
  - Type connection

- Further details for each is provided in the Terraform documentation.
- A popular function is `lookup`, which can be used to look up the value of a single element from a map given its key. If the key doesn't exist, a default value will be used.

- Example: `lookup(map, key, default)`

- Another function is `element`, which retrieves a single element from a list, example usage: `element(list, index)`
