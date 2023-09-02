# 9.11 - IP Address Management - Weave

- How are the virtual networks, nodes and pods assigned IPs?
- How do you avoid duplicate IPs
- The CNI plugin is responsible for assigning IPs
- To manage the IPs, Kubernetes isn't bothered how they're managed
  - Could do it via referencing a list
  - CNI comes with 2 built in plugins to leverage this, the host_local plugin or
dynamic
- CNI conf has sections determining the plugins, routes and subnet used
- Various network solutions have different approaches
- Weave by default allocates the range `10.32.0.0/12` => 10.32.0.0 - 10.47.0.0, ~1 million IPs available, each node gets a subrange of this range defined
