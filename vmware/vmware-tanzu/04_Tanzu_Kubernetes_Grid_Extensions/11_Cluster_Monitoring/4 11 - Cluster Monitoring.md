# 4.11 - Cluster Monitoring

Tags: Done

# Objectives

- Describe Prometheus
- Describe Grafana

# Monitoring

- TKG provides cluster monitoring services via the two projects:
    - Prometheus:
        - A systems monitoring and alerting toolkit
        - Collects metrics from clusters and applications at specific intervals
        - Triggers alerts depending on conditions
    - Grafana:
        - Visualization and analytics software
        - Allows query, visualization, and alerting operations for metrics; as well as alerting

# Architecture

![Untitled](4%2011%20-%20Cluster%20Monitoring%202b3260e85d35426d8906b742e4ccf447/Untitled.png)

# Prometheus Components

- Standard Prometheus deployment comes with the following components:

![Untitled](4%2011%20-%20Cluster%20Monitoring%202b3260e85d35426d8906b742e4ccf447/Untitled%201.png)

# Prometheus Configuration Options

- Default prometheus configuration values are generally fine, but for particular use cases the `prometheus-data-values.yaml` file can be edited with options such as:

![Untitled](4%2011%20-%20Cluster%20Monitoring%202b3260e85d35426d8906b742e4ccf447/Untitled%202.png)

# Grafana

- An open-source monitoring and observability platform
- Can connect to and pull data from many sources
- Provides dynamic dashboards, graphs and visualization for Prometheus backend data.

# Grafana Configuration Options

- Similar to Grafana configuration, the `grafana-data-values.yaml` file must be edited with parameters, including the following, to work:

![2022-10-05_13h20_04.png](4%2011%20-%20Cluster%20Monitoring%202b3260e85d35426d8906b742e4ccf447/2022-10-05_13h20_04.png)