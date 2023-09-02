# 2.1 - The Attack

## Demonstration of attacks on a Kubernetes environments

- Consider a Kubernetes application set running online, with two applications running in a domain each
- Suppose someone wanted to mess with these applications, the only initial
information they have is the domain names, the architecture remains unknown
- Determining the IP addresses: `ping <domain name>`
  - The same IP address is returned for each, implying they are on the same
server/infrastructure set
- Port scan of the IP address: `zsh port-scan.sh <IP address>`
  - All bar one port has a successful connection, Docker, implying that the
applications are container-based
- Knowing the docker port is available, the next consideration is whether any authentication and authorization measures are in place within Docker
  - This is not enabled by default, IT MUST BE PRE-CONFIGURED.
- Testing the waters for the Docker infrastructure:
  - `docker ps -H <domain name>`
    - The -H flag is used to specify the host, if not specified it will default to localhost
  - As no Docker authentication and authorization measures are in place, this shows all the containers within the infrastructure
- Docker version can also be identified by running `docker -H <domain name> version`
- To access the environment and other containers:
  - `docker -H <domain name> run --privileged -it ubuntu bash`
  - Runs a basic ubuntu container with escalated privileges within the infrastructure, allowing ssh'ing into other containers within the infrastructure
- Suppose the hacker already has a script capable of exploiting the infrastructure's vulnerability(ies), they should be able to download it to their privileged container without issue:
  - Curl not found
  - Wget not found
  - Apt-get install <curl>
  - Apt-get update
  - Since the authentication isn't in place, the packages can be successfully installed and the hacker can run their script(s) to infiltrate the underlying infrastructure and mess around with the other applications, or learn additional information about the system e.g.:
    - Volume mounts: `df -h`
    - Username currently on system: `uname`
    - Host name: `hostname`
    - Additional containers: `sudo docker ps`
- Running these commands allows identification of a Kubernetes workload running in a container with Kubernetes-dashboard
- The Kubernetes dashboard must be running on a port somewhere, run `sudo
iptables -L -t nat | grep kubernetes-dashboard`
  - Shows dashboard running on 30080
  - Dashboard can be accessed and viewed easily if there's no authentication
and security controls setup
  - The dashboard provides information about pretty much everything within your Kubernetes cluster relating to storage, workloads, etc
  - Using this, information can be identified for the database container such as the authentication parameters, in this case they're listed as environment variables
  - From here the database container can be accessed and manipulated to the hacker's desire
- ALL OF THIS can be resolved via implementation of Kubernetes security measures discussed within this course.
