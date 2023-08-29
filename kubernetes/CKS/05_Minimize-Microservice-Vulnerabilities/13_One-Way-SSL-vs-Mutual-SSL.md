# 5.13 - One-Way SSL vs Mutual TLS (mTLS)

- **One-Way SSL:**
  - Receivers can only verify identities based on the information sent by clients
e.g. emails, social media using usernames and passwords
- If there is no end-user to provide the information e.g. two services, what then?
  - **Mutual SSl is required:**
    - Client and Server verify their identities
    - When requesting data from the server, the client requests the servers public certificates
    - When the server sends it back, it requests the clients certificate and the client verifies the server certificate with the CA it uses
    - Once verified, the client sends its certificate with a symmetric key encrypted with the server's public key
    - The server then validates the client certificate via the CA.
- Once both certificates are verified, all communication can be encrypted using the symmetric key.