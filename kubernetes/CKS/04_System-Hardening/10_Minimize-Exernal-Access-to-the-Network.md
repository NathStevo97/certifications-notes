# 4.10 - Minimize External Access to the Network

- To view the ports that are open and listening for requests on your system, utilize the
netstat command:
netstat -an | grep -w LISTEN
- By default, many of these ports can accept connections from any other device on
the network - undesirable via the principle of least privilege
- In production environments, with multiple clients and servers involved, it's beyond
important to implement network security to only allow or restrict access to various
services
- Security can be provided via network-wide or external firewalls e.g.
  - Cisco ASA
  - Juniper NGFW
  - Barracuda NGFW
  - Fortinet
- Alternatively, firewalls can be applied per server.