# 9.2 - Prerequisite: DNS

- Used to assign text names to ip addresses, saving the need to remember manual ip
addresses
- Can assign names in `/etc/hosts`, write the IP and name in key-value pairs
- Note: No checks would be done by the system when done in this manner to check
the hostname
- As environments grow, modifying the `/etc/hosts` becomes impossible
- Moved to Domain Name Server for centralized management
  - Host will point to the DNS server to resolve any names unknown to them
- For any changes that need to be made, just the one change needs to be made in the
DNS server, all hosts will register it
- Note: custom entries can still be added in the `/etc/hosts` file, though this is better for
local networking
- If both the DNS and the `/etc/hosts` file contains the same IP address for an entry, it
looks in the `/etc/hosts` file first, then DNS, taking whichever one comes first
- Record types:
  - A - Domain Name - IP address
  - AAAA - Domain name to full Address
  - CNAME - 1-to-1 name mapping for the same IP
- Dig - tool to test DNS resolution (dig <DNS NAME>)
