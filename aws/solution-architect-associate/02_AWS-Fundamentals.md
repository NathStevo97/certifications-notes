# 2.0 - AWS Fundamentals

## 2.1 - Availability Zones and Regions

- ~24 Regions and 77 Availability Zones
- **Regions:**
  - A general geographic location that consists of 2 or more availability zones.
- **Availability Zone:**
  - A data center within a region.
  - Availability zones may have multiple data centers within them, geographically located in close proximity such that they can be classed as one "zone" (within 100km of each other)
- **Edge Locations**
  - Endpoints for AWS, used for caching content
  - Primarily consists of CloudFront - AWS's content delivery network (CDN)
  - Over 215 edge locations available - many more than regions.

- There are many service types available, each with their own subset of services.
- Knowledge of all the services is NOT required for the exam, just the "key" ones:
  - Compute
  - Storage
  - Databases
  - Migration and Transfer
  - Network and Contend Delivery
  - Management and Governance
  - Analytics
  - Security, Identity and Compliance
  - Application Integration
  - AWS Cost Management
  - Containers

### Summary Points

- Region = physical location consisting of 2 or more availability zones
- Availability Zone (AZ) = One or more data centers with redundant power, networking and connectivity with their own facilities
- Edge Location = Endpoints used by AWS for caching content, used mainly by AWS CloudFront.

---

## 2.2 - Who Owns What In the Cloud?

- The shared responsibility model determines what particular resources AWS and its customers are responsible for.
- In short, AWS is responsible for the security OF the cloud resources used. Customers are responsible for security IN the cloud.
- AWS are responsible for effectively ensuring the services used by the customer are available and secure, such as:
  - Regions
  - Availability Zones
  - Edge Locations
  - Hardware and Global Infrastructure
  - Compute
  - Storage
  - Database
  - Networking
  - Software
- Customers are responsible for effectively the "what" they use in AWS and "how" they use it, mainly the security of:
  - Customer data
  - Platforms / Applications / Identity and Access Management
  - Operating System, Network and Firewall Configurations
  - Client-side data encryption and data integrity authentication
  - Server-side encryption (file system and/or data)
  - Networking Traffic Protection (Encryption, Integrity, Identity)

- **Exam Tip**:
  - When given a scenario question, ask "can you do this yourself in the AWS Console?"
  - If yes - YOU / Customer is responsible e.g. security groups, management of IAM users, patching of EC2 instances or EC2 databases, etc.
  - If no - AWS is responsible e.g. management of data centres, patching Relational Database System operating systems.
  - Encryption is a SHARED RESPONSIBILITY.

---

## 2.3 - Compute, Storage, Databases and Networking

- **Compute:** Services that provide compute power to help build and deploy applications or functions.
  - Key services:
    - EC2
    - Lambda
    - Elastic Beanstalk

- **Storage:** How does the data get stored?
  - Key services:
    - S3
    - Elastic Block Store (EBS)
    - Elastic File Service (EFS)
    - FSx
    - Storage Gateway

- **Database:** Managing, storage and retrieval of information
  - Key services:
    - RDS
    - DynamoDB
    - Redshift

- **Networking:** How are the services above linked?
  - Key services:
    - VPCs
    - Direct Connect
    - Route 53
    - API Gateway
    - AWS Global Accelerator

---

## 2.3 - What is the Well-Architected Framework?

- Whitepapers are available via AWS detailing architecture best-practices and methodologies, including the well-architected framework.
- Each pillar of the well-architected framework has its own set of whitepapers.
- Pillars:
  - **Operational Excellence:** Running and monitoring systems to deliver business value, and continuously improving processes and procedures
  - **Performance Efficiency:** Using IT and computing resources efficiently - don't use any more than you have to!
  - **Security:** Protecting information and systems
  - **Cost-Optimization:** Avoid unnecessary costs
  - **Reliability:** Ensuring a workload performs its intended function correctly and consistently when it's expected to.
  - **Sustainability:** Minimize environmental impact of workloads.
- Advised to give the whitepaper a once-over before the exam.

---

## 2.4 - AWS Fundamentals Exam Tips

- 3 Tips for AWS Building Blocks:
  - Regions - Physical geographical areas consisting of 2 or more AZs
  - Availability Zones (AZs) -  a standalone datacenter within a region
  - Edge Locations - Endpoints for AWS typically used for caching content.

- Shared Responsibility Model:
  - If the answer is "yes" to the question "Can I do `<x>` task in the AWS Console?" - Then you as a user is responsible for it when using AWS.
  - AWS is responsible for tasks such as data center management and patching RDS operating systems
  - Both user and AWS are responsible for encryption

- Key services boil down to 4 categories:
  - Compute
  - Storage
  - Databases
  - Networking

- It's advised to give the whitepaper for the Well-Architected Framework before the exam.
