# 9.0 - Lookups

Status: Done

# 9.1 - Introduction

- Suppose instead of the inventory file, the credentials for servers were stored in another file
- To obtain the credentials, use `lookup`
- Example:
`{{ lookup('csvfile', ‘target1 file=/path/to/file delimiter=,') }}`
- In general:
`{{ lookup('<file type identifier>', ‘<target value> file=/path/to/file delimiter=<delimiter>') }}`
- Other lookup plugins are available e.g. MongoDB and INI - further information is available in the docs.
