# 3.8 - Pod Networking

- Inter-pod communication is hugely important in a fully operational environment for
Kubernetes
- At the time of writing, there is no built-in solution in Kubernetes for this, but the
requirements have been clearly identified:
  - Each pod should have an IP address
  - Each pod should be able to communicate with every other pod on the same
node
  - Every pod should be able to communicate with pods on other nodes without
NAT
- Solutions available include weaveworks, VMware etc

## Example - Configuring Pod Networking

- Consider a cluster containing 3 identical nodes. The nodes are part of an external network and have IP addresses in the 192.168.1 series (11, 12 and 13).
- When containers are created on pods, Kubernetes creates network namespaces for each of them, to enable communication between containers, can create a bridge network and the containers to it.
  - Running `ip link add v-net-0 type bridge` on each node, then bring them up with `ip link set dev v-net-0 up`
- IP addresses can then be assigned to each of the bridge interfaces of networks. In this case, suppose we want each personal network to be on its own subnet (/24).
  - The Ip address for the bridge interface can be set from here via `ip addr add 10.244.1.1/24 dev v-net-0` etc
- The remaining steps can be summarised in a script that is to be ran every time a new container is created.

```shell
#create veth pair
ip link add ....
#attach veth pair
Ip link set ....
Ip link set .....
#assign IP address
Ip -n <namespace> addr add ....
Ip -n <namespace> addr add ....
#bring up the interface
Ip -n <namespace> link set
```

- This script is run for the second container involved in the pair, with its respective information applied; allowing the two containers to communicate with one another.
  - The script is then copied and run on the other nodes; assigning IP addresses and connecting their containers to their own internal networks.
- This solves the first problem, all pods get their own IP address and can communicate with each other within their own nodes.
  - To extend communication across nodes in the cluster, create an ip route to each nodes' internal network via the nodes' IP address i.e. on each node, run: `ip route add <pod network ip> via <node IP>`

- For larger, more complex network, it's better to configure these routes via a central router, which is then used as a default gateway.
  - Additionally, we don't have to run the script manually for each pod, this can automatically be done via the CNI as it sets out predefined standards and how the script/operations look.
  - The script needs a bit of tweaking to consider container creation and deletion.

  ```shell
  --cni-conf-dir=/etc/cni/net.d
  --cni-bin-dir=/etc/cni/bin
  ./net-script.sh add <container> <namespace>
  ```