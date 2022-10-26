# 2.11 - TOTP Secrets Engine

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Notes

- TOTP = Time-Based One-Time-Passwords
- These are passwords that typically expire within 30, 60 seconds, etc.
- An example of this is Google Authenticator.
- Typically these TOTPs will regenerate with new values after the set timeframe.
- Vault offers both generation and provision services for TOTPs.
- To create, simply select TOTP from the list of secrets engines available. Note that you cannot now select it to open.

![Untitled](./2%2011%20-%20TOTP%20Secrets%20Engine//Untitled.png)

- For usage e.g. for a barcode:
    - Generate data for bar code:
        - `vault write --field=barcode totp/keys/<keyname> generate=true issuer=vault account_name=<user>`
        - The resultant output should follow - note that you must have the VAULT_ADDR environment variable for this to work
        
        ![Untitled](./2%2011%20-%20TOTP%20Secrets%20Engine//Untitled%201.png)
        
    - Write the data to a file, decode the data and store it in an image file:
    `cat <file containing code> | base64 -d > totp.jpg`
    - This will result in a barcode data that can be used by authentication apps like google authenticator.
    - The code can also be read from the Vault itself:
    
    ![Untitled](./2%2011%20-%20TOTP%20Secrets%20Engine//Untitled%202.png)