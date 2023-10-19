# 3.08 - Tools in Vault

## Vault Tools

- Vault contains tools allowing specific functions
- They are available at the `/sys/tools` endpoint
- Examples of tools include:
  - Wrap
  - Lookup
  - Unwrap
  - Rewrap
  - Random - Used to generate a secret of random bytes of a particular size and format
  - Hash - Used to hash data using a particular format and output it as a particular format
    - Note, sometimes input data may need to be encoded as base64 before hashing
- Random can be called via a POST request to `/sys/tools/random/{bytes number}`
- Hash can be called via a POST request to `/sys/tools/hash/{algorithm}`
  - Algorithm may be any of `sha2-224`, `sha2-256`, and so on.
- Additional details are available in the documentation, along with sample curl requests.
  - [Documentation](https://www.vaultproject.io/api-docs/system/tools).
- Common exam questions are "what does X Call aim to achieve?"
