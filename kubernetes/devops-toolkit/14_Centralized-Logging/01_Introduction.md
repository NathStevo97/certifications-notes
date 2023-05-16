# 1.0 - Introduction

- Previously, logs were stored in files only.
- This was fine for static infrastructure running small application numbers.

- Now, infrastructure is dynamic and highly scalable. This made finding logs in files harder, a centralized system is needed to support distributed infrastructure.
- This is now a defacto standard in modern iinfrastructure.
  - Examples include:
    - Datadog
    - Splunk
    - ElasticSearch Logstash Kibana (ELK Stack) -> One of the most commonly used.
      - ELK has its issues, creating a high-resource consumption in-memory datastore.
        - Highly problematic when introducing scaling and sharding to clusters, amongst other operations / features.
