# 7.16 - Developing Network Policies

- When developing network policies for pods, always consider communication from
the pods perspective
- PolicyTypes Available:
  - Ingress - Incoming traffic
  - Egress - Outgoing traffic
■ Both can be implemented if desired
- Each ingress rule has a from and ports field:
  - From describes the pods which the pod affected by the policy can accept
ingress communication
  - For additional specification, can use podSelector and namespaceSelector or ipBlock to specify particular IP addresses
  - Each rule start denoted by -
  - Ports - Network ports communication can be received from
- For egress rules, the only difference is "from" is replaced with "to"
