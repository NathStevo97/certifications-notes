# 9.4 - Prerequisite: Network Namespaces

- Used to implement network isolation
- Resources within a namespace can only access other resources within their
namespace
- Want containers to remain isolated when running a process; run in a namespace
  - Underlying host sees all processes associated with other containers
- Creating a new namespace: `ip netns add <namespace name>`
- To view namespaces: `ip netns`
- To execute a command in a namespace: `ip netns exec <namespace> <command>`
- While testing the Network Namespaces, if you come across issues where you can't ping one namespace from the other, make sure you set the `NETMASK` while setting IP Address. ie: 192.168.1.10/24

```shell
ip -n red addr add 192.168.1.10/24 dev veth-red
```

- Another thing to check is FirewallD/IP Table rules. Either add rules to IP Tables to allow traffic from one namespace to another. Or disable IP Tables all together (Only in a learning environment!).