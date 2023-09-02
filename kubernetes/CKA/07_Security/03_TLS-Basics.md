# 7.3 - TLS Basics

- Certificates used to guarantee trust between two parties communicating with one
another, leading to a secure and encrypted connection
- Data involved in transmission should be encrypted via the use of encryption keys
- Encryption Methods:
  - Symmetric: Same key used for encryption and decryption
  - Asymmetric encryption: A public and private key are used for encryption and
decryption specifically
■ Private key can only be used for decryption
- SSH Assymetric Encryption: `run ssh-keygen`
  - Creates `id_rsa` and `id_rsa.pub` (public and private keys)
  - Servers can be secured by adding public key to authorized key file at
`~/.ssh/authorized_keys`
  - Access to the server is then allowed via ssh -i id_rsa username@server
  - For the same user, can copy the public key to any other servers
- To securely transfer the key to the server, use asymmetric encryption
- Can generate keys with: `openssl genrsa -out <name>.key 1024`
  - Can create public variant with: `openssl rsa -in <name>.key -pubout > <name>.pem`
- When the user first accesses the web server via HTTPS, they get the public key from
the server
  - Hacker also gets a copy of it
- The users browser encrypted the symmetric key using the public key
  - Hacker gets copy
- Server uses private key to decrypt symmetric key
  - Hacker doesn't have access to the private key, and therefore cannot encrypt
it.
- For the hacker to gain access, they would have to create a similar website and route
your requests
  - As part of this, the hacker would have to create a certificate
  - In general, certificates must be signed by a proper authority
  - Any fake certificates made by hackers must be self-signed
■ Web browsers have built-in functionalities to verify if a connection is
secure
- To ensure certificates are valid, the Certificate Authorities (CAs) must sign and
validate the certs.
  - Examples: Symanteg, Digicert
- To validate a certificate, one must first generate a certificate validation request to be
sent to the CA: `openssl req -new -key <name>.key -out <<name>.csr -subk "/C=US/ST=CA/O=MyOrg, Inc./CN=mybank.com"`
- CAs have a variety of techniques to ensure that the domain is owned by you
- How does the browser know what certificates are valid? CAs have a series of public
and private keys built in to the web browser, the public key is then used for
communication between the browser and CA to validate the certificates
- Note: The above are described for public domain websites
- For private websites, such as internal organisation websites, private CAs are
generally required and can be installed on all instances of the web browser within
the organisation
- Note:
  - Certificates with a public key are named with the extension .crt or .pem, with
the prefix of whatever it is being communicated with
  - Private keys will have the extension of either `.key` or `-key.pem`
