# Exam Prep 1

Tags: Done

## Questions 1-10

### Question 1

A - Operational Excellence

Rationale: Technically all, but by adopting IAC, infrastructure deployments are made more consistent and reliable.

Additional Notes:

- Fault tolerance is not a pillar
- Security and Cost Optimization aren't fully related to IAC

### Question 2

B - Reserved 3-year no upfront

Additional Notes:

- Dedicated host = too expensive
- On-demand instance does not provide enough for the desired workload

### Question 3

C - Basic

Rationale: By elimination, all other plans would include and cost more.

### Question 4

B - Custom Amazon Machine Image (AMI)

Rationale: EC2 instances are created based on AMIs, for custom configs a custom AMI needs to be created.

### Question 5

C - Elastic Load Balancing

### Question 6

B - Agility

Rationale: Within a very quick amount of time the team have been able to spin up the required resources for experimentation.

Additional Notes:

- Elasticity relates more to scaling

### Question 7

B - Operational Excellence

C - Security

D - Cost-Optimization

Rationale: HA and Fault Tolerance are not pillars well-architected solutions (though they should be adopted if possible!)

*Got wrong initially

### Question 8

B - Region

Rationale: Regions have multiple AZs, AZs have edge locations, etc.

### Question 9

C - Security Groups

Rationale: Security Groups can have inbound/outbound rules set to limit traffic.

### Question 10

C - AWS Direct Connect

Additional Notes:

- VPN is over public internet.

*Got wrong initially

## Questions 11-20

### Question 11

A - S3

Rationale: Other services do not offer the varying levels of access.

### Question 12

C - AWS Virtual Private Network (VPN)

### Question 13

A - CloudFormation

Rationale:

- Resource Manager is for managing resources
- CodeCommit and CodeDeploy are for CI/CD operations

### Question 14

A - Duration (based on memory allocated)\

D - Number of requests

Rationale: If it's a resource intensive Lambda AND frequently used then those require greater consideration.

No charges applied based on instances

### Question 15

D - Loose Coupling

Rationale: Avoid tight coupling, HA and Least Privilege Access don't relate to the statement

### Question 16

D - AWS Control Tower

Rationale: Cost explorer is unrelated, as is IAM

### Question 17

D - AWS Organisations

Rationale: Only one that makes sense.

### Question 18

B - Amazon RDS

### Question 19

B - AWS CodeDeploy

### Question 20

C - Amazon DynamoDB

## Questions 21-30

### Question 21

B - Custom Software Development

Rationale: TCO highlights areas of cost differences for on-prem vs cloud - question is asking "what is effectively gonna be the same"

### Question 22

- User Access Management
- Encryption of data at rest and in transit

Rationale: Edge location is managed by AWS, as is datacenter connectivity

*Got wrong initially

### Question 23

- Backup and Restore

### Question 24

C - Reducing unused capacity

### Question 25

D - AWS Macie

Rationale: Cloudformation is infra-related, GuardDuty and ACLs are network focussed.

*Got wrong initially

### Question 26

C - AWS Pricing Calculator

### Question 27

B - AWS Route53

### Question 28

B - Security

Rationale: Incident Management = Security

*Got wrong initially

### Question 29

C - Grant the user permissions for only the items needed by that user to perform a task

### Question 30

D - Amazon S3

## Questions 31-40

### Question 31

A - AWS Trusted Advisor

### Question 32

C - AWS Well-Architected Framework

Rationale: Only one that makes sense for "before" deploying anything

### Question 33

A - Business

### Question 34

C - AWS Web Application Firewall

### Question 35

B - Go Global in Minutes

### Question 36

D - Patching the OS on EC2 Instances

### Question 37

B - Access keys per IAM user

### Question 38

D - AWS CloudTrail

### Question 39

B - Create an IAM group, assign permissions to the group, and add IAM users to the group

### Question 40

B - AWS CloudHSM

## Questions 41-50

### Question 41

A - AWS Storage Gateway

Rationale: The only one that allows for local storage

### Question 42

A - Amazon Elasticache

Rationale: The online one that makes sense.

### Question 43

C - Design for Failure

### Question 44

A - Amazon Machine Image (AMI)

### Question 45

C - Increase speed and agility

### Question 46

D - Availability Zone

### Question 47

C - Enable Multi-Factor Authentication

### Question 48

A - Spot Instance

Rationale: Flexible start/stop time & can stop and restart when needed

*Got wrong initially

### Question 49

A - Sustainability

### Question 50

D - High-Availability

## Questions 51-60

### Question 51

C - Utilize MySQL on Amazon EC2

Rationale: In RDS you have no access to the root OS.

### Question 52

B - Dedicated Host

Rationale: Ensures a per-server license can be maintained.

*Got wrong initially

### Question 53

D - AWS Cost Explorer

Rationale: C only allows for current usage, D allows for future estimations etc.

*Got wrong initially

### Question 54

A - AWS Organisations

Rationale: Cloudwatch is auditing, Cloudformation is IAC, Direct Connect is network-based.

### Question 55

D - Developer

### Question 56

C - Amazon Elastic File System (EFS)

### Question 57

A - AWS Professional Services

Rationale: D is resources external to AWS, A is the only internal one.

### Question 58

D - Amazon Redshift

### Question 59

C - Configuration Management

Rationale: Customer data is handled by customer, Data center physical security and edge location management is handled by AWS.

### Question 60

D - Reduced total cost of ownership (TCO)

Rationale: Any increased costs goes against the question, we're not ELIMINATING outright the Opex costs.

## Questions 61-65

### Question 61

B - AWS Config

Rationale: All other services in the questions don't provide the services required.

### Question 62

C - Reliability

### Question 63

C - AWS Snowball

### Question 64

D - Stop guessing capacity

Rationale: The only one that makes sense

### Question65

D - Hybrid Cloud

## Initial Evaluation

- 57/65 = 87%
- Passing grade
