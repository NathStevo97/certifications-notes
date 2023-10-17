# 4.7 - Restrict Kernel Modules

- Linux kernel modules has a modular design - its functionality can be extended via the addition of extra modules
- Example - Hardware support for video drivers via graphics cards
- Modules can be added manually - `modprobe <module name>`
- List modules in the Kernel - lsmod
- **Note:** When kubernetes workloads are running, non-root processes on pods may cause network-related modules to be installed on the Kernel - This can lead to vulnerabilities exploited by attackers.
- To mitigate, modules on cluster nodes can be blacklisted - achievable by creating a `.conf` file under `/etc/modprobe.d`
  - Any modules to be blacklisted should be included as an entry via: `blacklist <modulename>`
  - Upon entry addition, the system should be restarted and tests should be ran to see if the module is still running: <br>`shutdown -r now` <br> `lsmod | grep <modulename>`
- Example modules that should be blacklisted - `sctp` and `dccp`
- Additional information available in section 3.4 of the CIS Benchmarks
