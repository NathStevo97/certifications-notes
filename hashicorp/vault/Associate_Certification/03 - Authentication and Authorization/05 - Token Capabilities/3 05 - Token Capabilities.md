# 3.05 - Token Capabilities

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Notes

- Users can check the capabilities of a token for a particular path using the `token capabilities` command
- Example:
    - `vault token capabilities sys`
    - `vault token capabilities <path>`
- When using this, if you you do not explicitly specify a token, Vault will assume the token of the user making the request is the token to be checked.
- If a token is provided as an argument, the “/sys/capabilities” endpoint and permission is used.
- If no token is provided, the “/sys/capabilities-self” endpoint and permission is used with the locally authenticated token
- To provide the token as an argument, simply add the token prior to the <path>

---