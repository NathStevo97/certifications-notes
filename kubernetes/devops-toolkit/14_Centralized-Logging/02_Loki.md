# 14.2 - Using Loki

- [14.2 - Using Loki](#142---using-loki)

- Grafana introduced Loki as "like prometheus, but for logs".
- Prometheus is already a leading technology - Loki aimed to remove text-indexing, introducing labels to log lines in a similar vein to Prometheus metrics labels.
  - Loki actually uses the same metrics labelling library as Prometheus.

- Indexing is very compute-intensive, causing issues at scale. Using labels reduces the intensity; making it more efficient.
- Using the same set of labels from application logs and metrics helps with correlations.
- Logs are queried with PromQL - the same query language used by Prometheus for querying metrics. Specifically, Loki uses a subset of PromQL called LogQL.
  - Even if not using Prometheus, PromQL is being implemented across many tools, so using a subset makes sense and provides a good learning opportunity.

- The UI for exploring logs is based on Grafana - the defacto standard in observability.
- Grafana now has in-built support for Loki to query both logs and metrics in the same view from Loki and Prometheus respectively.
