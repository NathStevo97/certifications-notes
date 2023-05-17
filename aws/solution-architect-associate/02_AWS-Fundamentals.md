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

## 2.2 - Who Owns What In the Cloud?

- 