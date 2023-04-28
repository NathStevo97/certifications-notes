# 2.12 - Terraform Debugging

- Terraform tracks all changes in a series of logs, which can be enabled by setting the environment variable `TF_LOG`.
  - Accepted values are:
    - TRACE
    - DEBUG
    - INFO
    - WARN
    - ERROR
- Set `TF_LOG` via `export TF_LOG=<value>`
- To save logs, set `TF_LOG_PATH=/path/to/log/file`

- Now when all commands are ran, the logs are pushed to the path set in `TF_LOG_PATH`
- `TRACE` is the most extensive overview and the default setting for `TF_LOG`, the logs increase in verbosity in the order of the list above.
