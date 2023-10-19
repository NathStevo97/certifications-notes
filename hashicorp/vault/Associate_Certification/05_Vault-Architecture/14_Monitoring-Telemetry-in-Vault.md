# 5.14 - Monitoring Telemetry in Vault

## Overview

- Telemetry covers any data being output by a particular device.
- Analysis of this can be useful for areas such as:
  - Performance
  - Troubleshooting
- In Vault, there are two data sets to note:
  - Metrics - Output via Telegraf
  - Vault Audit Logs - Output via Fluentd
- These metrics can be output to various tools such as Prometheus.

## Metrics Output

- Further details for each metric are available in the documentation, however metrics covered include:
  - Policy-based
  - Token-based
  - Resource usage

## Configuration

- In the Vault Server config, one can add a config block to the file to point to a particular location for the metrics to be exported to.

```go
telemetry {
  statsite_address = "statsite.company.local:8125"
}
```

- Metrics can also be fetched from the `/sys/metrics` endpoint
  - Sample curl requests are available in the documentation
  - The format of the metrics can be configured e.g. JSON, Prometheus
  - e.g. `curl --header "X-Vault-Token: <token>" 127.0.0.8200:/v1/sys/metrics`
- Additional documentation is available for configuring Vault with various monitoring integrations; including Splunk.
