# 1.0 - Important Data Characteristics to Consider in a Machine Learning Solution

## 1.1 - Course Overview

- **Topics to be covered include:**
  - Choosing the best data repository
  - What machine learning use cases can be used with different services
  - Performance Analytics and ETL
  - Automating data engineering

## 1.2 - Choosing an AWS Data Repository

- Data type characteristics determine the preferred type of repository. Typically data is:
  - **Structured:**
    - Relational
    - Has a predefined schema
    - Relationships exist between tables
    - Recommended Services:
      - Amazon Relational Database Service (RDS)
      - Amazon Redshift
  - **Semi-Structured:**
    - JSON/XML-based
    - Key-value data
    - Document data
    - Recommended Services:
      - DynamoDB
  - **Unstructured:**
    - Heterogeneous data types
    - Object storage
    - Recommended Services:
      - AWS S3

## 1.3 - Choosing AWS Data Ingestion and Data Processing Services

- **Batch Processing Characteristics:**
  - Data scope is limited to querying or processing over all or most of the data set
  - Data size is in the form of large batches
  - Data performance in terms of latency, typically ranges from minutes to hours
  - Analysis of batch processing is complex
- **Stream Processing Characteristics:**
  - Queries are done against the most recent data only
  - Data size is typically individual records or micro-batches (a few records apiece)
  - Performance has latency ranging from milliseconds to seconds
  - Analysis is typically displayed by simple response functions, aggregates, and rolling metrics.

## 1.4 - Refining What Data Store to Use Based on Application Characteristics

- Modern cloud applications have varying requirements, therefore it's important to make the correct decision regarding data store.
- Traditional apps have 100s-1000s of users, whilst cloud apps have in excess of 1 million.
- Data volume in cloud apps ranges from TeraByte (Tb), PetaByte (Pb) to ExaBytes (Pb)
- Resource locality is worldwide instead of in corporate headquarters
- Performance times can range from micro to milliseconds.
- Request rate can be in the millions per seconds.
- Cloud apps can typically be accessed from any device with access to the internet, rather than internal servers or pcs.
- Cloud apps are expected to scale up/down to suit demand, whereas traditional apps could only scale up.
