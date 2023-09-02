# 3.10 - CNI Weave

- Becomes important when significant numbers of routes are available
- Deploys an agent or service on each node and communicates with other nodes agent
- Weave creates its own inter-node network, each agent knows the configuration and location of each node on the network, helping route the packages from one node to another, which can then be sent to the correct pod
- Weave can be deployed manually as a daemonset or via pods
- `kubectl apply -f "https://cloud.weave.works/k8s...`.
- Weave peers deployed as daemonsets