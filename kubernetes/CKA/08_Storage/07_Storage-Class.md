# 8.7 - Storage Class

- Allows definition of a provisioner, so that storage can automatically be provisioned
and attached to pods when a claim is made
- Make storage classes using yaml files to define a particular storage class
- To use the storage class, specify it in the pvc definition file
- Still creates a PV, BUT doesn't require a definition file
- Provisioners available include:
  - AWS
  - GCP
  - Azure
  - ScaleIO
- Additional configuration options available for different provisioners, so you could
have multiple storage classes per provisioners
