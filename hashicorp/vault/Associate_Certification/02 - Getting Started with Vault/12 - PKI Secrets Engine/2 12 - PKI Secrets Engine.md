# 2.12 - PKI Secrets Engine

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

# Notes

- Disclaimer - PKI is a huge topic in itself, however for the purposes of the certification, you can only consider it at a high level.
- Certificate Authority:
    - Any entity that issues digital certificates
    - Both the receiver and sender have a trusted relationship with the CA during the process.
    - The certificate authority validates the address/domain being accessed and the users accessing the domain.
- Typically, CAs work via the following process:
    1. Users/Entities generate a Certificate Signing Request (CSR)
        1. Generate public/private keys
        2. Generate CSR and have it signed with a private key
    2. Submit the CSR to the CA to get it signed
- The above steps are typically achieved via the openssl tool:

```powershell
# Create base directory for certificates and keys
mkdir /root/certificates
cd /root/certificates

# Create a private key for the CA
openssl genrsa -out ca.key 2048

# Create a CSR
openssl req -new -key ca.key -subj "/CN-KUBERNETES-CA" -out ca.csr

# Self-sign the CSR
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000
```

- The PKI Secrets Engine Provided by HashiCorp Vault aims to simplify this process by generating dynamic X509 certificates.
    - This removes the need for manual generation of certificates as outlined in the steps above - Vault acts as the CA.
- PKI Secrets Engines can be implemented easily enough via the Vault UI. Once done, selecting "issue certificate" and the common name will allow generation of the certificate.

## Benefits of PKI In Vault

- Vault can act as an Intermediate CA i.e. a liaising certificate authority between the identity certificate authority and a third-party root CA.
- It reduces or eliminates certificate revocations
- Reduces time to get certificate by eliminating the need to generate a private key and a CSR.