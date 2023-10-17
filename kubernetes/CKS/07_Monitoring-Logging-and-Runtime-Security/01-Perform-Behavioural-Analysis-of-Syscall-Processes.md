# 7.1 - Perform Behavioural Analytics of Syscall Processes

- Various ways of securing kubernetes clusters have been discussed so far:
  - Securing kubernetes nodes
  - Minimizing microservices vulnerabilities
  - Sandboxing techniques
  - MTLS Encryption
  - Network Access Restriction
- No guarantee that utilising these 100% prevents the possibility of an attack, how can one prepare for the possibility?
In general for vulnerabilities, the sooner that the possibility of a vulnerability has
been exploited is noted, the better
- Actions that could be taken include:
  - Alert notifications
  - Rollbacks
  - Set limits for transactions or resource usage
- Identifying breaches that have already occurred can be done using tools like Falco
  - Syscalls can be monitored by tools like tracee
  - Need to analyse syscalls like these in real time to monitor events occurring
within the system and note any of suspicious nature
    - Example - Accessing a containers bash shell and going to the `/etc/shadow` section, deleting logs,
