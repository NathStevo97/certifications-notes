# 9.1 - Prerequisite: Switching Routing

- To connect two hosts to one another, need to connect them to a switch, which
creates a network connection
- Need an interface on the host, viewable via `ip link`
- Assign the system with IP addresses of the same network: `ip addr add <IP> <namespace> <networkname>`
- For systems on other networks, need a router for inter-switch communication
  - Has an IP address for each network that it can communicate with
- Gateway - Setup to help route requests to a particular location, view via route
  - Add via `ip route add <IP> via <IP>`
- For the internet, can set default gateway so any requests to a network outside of the
current can be sent to the internet - `ip route add default via <Router IP>`
- If multiple routers, entries required for each to setup gateway
- `ip route add <IP> via <IP>`
- To check connection - `ping <IP>`
- Whether data is forwarded is defined by `/proc/sys/net/ipv4/ip_forward` (set to 1 by
default)
- `ip link` - List and modify interfaces on the host
- `ip addr` - see ip addresses assigned to interfaces described in ip link
- Ip addr add - Add IP addresses to interface
- Note: Any changes made via these commands don't persist beyond a restart,
to ensure they do, edit the `/etc/network/interfaces` file
- Ip route (or just route) - View routing table
- Ip route add - add entries into the ip routing table
