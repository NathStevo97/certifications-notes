# 9.0 - Networking

- [9.0 - Networking](#90---networking)
  - [9.1 - Prerequisite: Switching Routing](#91---prerequisite-switching-routing)
  - [9.2 - Prerequisite: DNS](#92---prerequisite-dns)
  - [9.3 - Prerequisite: CoreDNS](#93---prerequisite-coredns)
  - [9.4 - Prerequisite: Network Namespaces](#94---prerequisite-network-namespaces)
  - [9.5 - Prerequisite: Docker Networking](#95---prerequisite-docker-networking)
  - [3.6 - Prerequisite: CNI](#36---prerequisite-cni)
  - [3.7 - Cluster Networking](#37---cluster-networking)
    - [Note on CNI and the CKA Exam](#note-on-cni-and-the-cka-exam)
  - [3.8 - Pod Networking](#38---pod-networking)
    - [Example - Configuring Pod Networking](#example---configuring-pod-networking)
  - [3.9 - CNI in Kubernetes](#39---cni-in-kubernetes)
  - [3.10 - CNI Weave](#310---cni-weave)
  - [9.11 - IP Address Management - Weave](#911---ip-address-management---weave)
  - [9.12 - Service Networking](#912---service-networking)
  - [9.13 - DNS in Kubernetes](#913---dns-in-kubernetes)
  - [9.14 - CoreDNS in Kubernetes](#914---coredns-in-kubernetes)
  - [9.15 - Ingress](#915---ingress)

## 9.1 - Prerequisite: Switching Routing

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

## 9.2 - Prerequisite: DNS

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
- Dig - tool to test DNS resolution (`dig <DNS NAME>`)

## 9.3 - Prerequisite: CoreDNS

- We are given a server dedicated as the DNS server, and a set of Ips to configure as entries
in the server.
- There are many DNS server solutions out there, in this lecture we will focus on a particular one - CoreDNS.
- So how do you get core dns? CoreDNS binaries can be downloaded from their Github
releases page or as a docker image.
- Let's go the traditional route. Download the binary
using curl or wget. And extract it. You get the coredns executable.
- Run the executable to start a DNS server. It by default listens on port 53, which is the default port for a DNS server.
- Now we haven't specified the IP to hostname mappings. For that you need to provide some configurations.
There are multiple ways to do that. We will look at one. First we put all of the entries into the DNS servers `/etc/hosts` file.
- And then we configure CoreDNS to use that file. CoreDNS loads it's configuration from a file
named Corefile.
- Here is a simple configuration that instructs CoreDNS to fetch the IP to hostname mappings from the file `/etc/hosts`. When the DNS server is run, it now picks the Ips and names from the `/etc/hosts` file on the server.
- CoreDNS also supports other ways of configuring DNS entries through plugins. We will look at the plugin that it uses for Kubernetes in a later section.

## 9.4 - Prerequisite: Network Namespaces

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

## 9.5 - Prerequisite: Docker Networking

- Run a docker container without attaching it to a network (specified by none
parameter) - `docker run --network none <containername>`
- Attach a container to a host's network - `docker run --network host <containername>`
  - For whatever the port the container runs on, it will be available on the same
port at the hosts IP address (localhost)
- Setup a private internal network which the docker host and containers attach
themselves to: `docker run <containername>`
- When docker's installed it creates a default network called bridge (when viewed by
docker) and `docker0` (when viewed via `ip link`)
- Whenever `docker run <containername>` is ran, it creates its own private namespace
(viewable via ip netns) and `docker inspect <namespace>`
- Port mapping:
  - For a container within the private network on the host, only the containers
within the network can view it
  - To allow external access, docker provides a port mapping option: appending `-p <hostport>:<containerport>` to the docker run command

## 3.6 - Prerequisite: CNI

- A single program encompassing all the steps required to setup a particular network
type, for example `bridge add <container ns> /path/`
- CNI Defines a set of standards that define how programs should be developed to
solve and perform network operations with containers
- Any variants developed in line with the CNI are plugins
- Docker doesn't use CNI, instead adopting CNM (container network model)
  - Can't use certain CNI plugins with Docker instantly, instead would have to
create a none network container, then manually configure CNI features

## 3.7 - Cluster Networking

- Each node within a cluster must have at least 1 interface connected to a network
- Each node's interface must have an IP address configured
- Hosts must each have a unique hostname and unique MAC address
  - Particularly important if cloning VMs
- Ports need to be opened:
- APIServer (Master Node) - Port 6443
- Kubelet (Master and Worker) - Port 10250
- Kube-Scheduler (Master) - Port 10251
- Kube-Controller-Manager - Port 10252
- ETCD - Port 2379
- Note: 2380 In addition for the case where there are multiple master nodes (allows
ETCD Clients to communicate with each other

### Note on CNI and the CKA Exam

- In the upcoming labs, we will work with Network Addons. - This includes installing a network plugin in the cluster.
- While we have used weave-net as an example, please bear in mind that you can use any of the plugins which are described here:

- <https://kubernetes.io/docs/concepts/cluster-administration/addons/>
-<https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model>

- In the CKA exam, for a question that requires you to deploy a network addon, unless specifically directed, you may use any of the solutions described in the link above.
- However, the documentation currently does not contain a direct reference to the exact command to be used to deploy a third party network addon.
- The links above redirect to third party/ vendor sites or GitHub repositories which cannot be
used in the exam.
  - This has been intentionally done to keep the content in the Kubernetes documentation vendor-neutral.
- At this moment in time, there is still one place within the documentation where you can find the exact command to deploy weave network addon:
- <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#steps-for-the-first-control-plane-node>

## 3.8 - Pod Networking

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

### Example - Configuring Pod Networking

- Consider a cluster containing 3 identical nodes. The nodes are part of an external network and have IP addresses in the 192.168.1 series (11, 12 and 13).
- When containers are created on pods, Kubernetes creates network namespaces for each of them, to enable communication between containers, can create a bridge network and the containers to it.
  - Running `ip link add v-net-0 type bridge` on each node, then bring them up with `ip link set dev v-net-0 up`
- IP addresses can then be assigned to each of the bridge interfaces of networks. In this case, suppose we want each personal network to be on its own subnet (/24).
  - The Ip address for the bridge interface can be set from here via `ip addr add 10.244.1.1/24 dev v-net-0` etc
- The remaining steps can be summarised in a script that is to be ran every time a new container is created.

```shell
##create veth pair
ip link add ....
##attach veth pair
Ip link set ....
Ip link set .....
##assign IP address
Ip -n <namespace> addr add ....
Ip -n <namespace> addr add ....
##bring up the interface
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

## 3.9 - CNI in Kubernetes

- CNI Defines the best practices and standards that should be followed when
networking containers and the container runtime
- Responsibilities include:
  - Creating namespaces
  - Identifying the network a container should attach to
  - Invoke the associated network plugin (bridge) when a container is added and
deleted
  - Maintain the network configuration in a JSON format
- CNI Must be invoked by the Kubernetes component responsible for container
creation, therefore its configuration is determined by the kubelet server
- Configuration parameters for CNI in Kubelet (kubelet.service):
  - `--network-plugin=cni`
  - `--cni-bin-dir=/opt/cni/bin/`
  - `--cni-conf-dir=/etc/cni/net.d/`
- Can see these options by viewing the kubelet process
- CNI bin contains associated network plugins e.g. bridge, flannel
- Conf dir contains config files to determine the most suitable one
  - If multiple files, considerations made in alphabetical order
- IPAM section in conf considers subnets, IPs and routes etc

## 3.10 - CNI Weave

- Becomes important when significant numbers of routes are available
- Deploys an agent or service on each node and communicates with other nodes agent
- Weave creates its own inter-node network, each agent knows the configuration and location of each node on the network, helping route the packages from one node to another, which can then be sent to the correct pod
- Weave can be deployed manually as a daemonset or via pods
- `kubectl apply -f "https://cloud.weave.works/k8s...`.
- Weave peers deployed as daemonsets

## 9.11 - IP Address Management - Weave

- How are the virtual networks, nodes and pods assigned IPs?
- How do you avoid duplicate IPs
- The CNI plugin is responsible for assigning IPs
- To manage the IPs, Kubernetes isn't bothered how they're managed
  - Could do it via referencing a list
  - CNI comes with 2 built in plugins to leverage this, the host_local plugin or
dynamic
- CNI conf has sections determining the plugins, routes and subnet used
- Various network solutions have different approaches
- Weave by default allocates the range `10.32.0.0/12` => 10.32.0.0 - 10.47.0.0, ~1 million IPs available, each node gets a subrange of this range defined

## 9.12 - Service Networking

- Don't want to make each pod communicate with one another, can use services to
leverage this
- Each service runs at a particular IP address and is accessible by any pod from any
node, they aren't bound to a particular node
- ClusterIP = Service exposed to particular cluster only
- NodePort = Runs on a particular port on all nodes, with its own IP
- How are these services allocated IP addresses, made available to users, etc
- Each kubelet server watches for cluster changes via the api-server, each time a pod
is to be created, it creates the pod and invokes the CNI plugin to configure the
networking for it
- Kube-proxy watches for any changes, any time a new service is created, it's invoked,
however these are virtual objects.
- Services are assigned an IP from a predefined range, associated forwarding rules
are assigned to it via the `kube-proxy`
- The kube-proxy creates the forwarding rules via:
  - Listening on a port for each service and proxies connections to pods
(userspace)
  - Creating ipvs rules
  - Use IP tables (default setting)
- Proxy mode configured via: `kube-proxy --proxy-mode <proxy mode>`
- When a service is created, kubernetes will assign an IP address to it, the range is set
by the `kube-api server option --service-cluster-ip-range ipNet`
  - By default, set to `10.0.0.0/24`
- Network ranges for services, pods etc. should never overlap as this causes conflicts
- `iptables -L -t net | grep <service>`
  - Displays rules created by kube-proxy for service

## 9.13 - DNS in Kubernetes

- Consider a 3-node cluster with pods and services
- Nodenames and IP addresses stored in DNS server
- Want to consider cluster-specific DNS
- Kubernetes by default deploys a Cluster-DNS server
- Manual setup required otherwise
- Consider 2 pods with one running as a service, each pod being on different nodes
- Kubernetes DNS service creates a DNS record for any service created (name and IP
address)
- If in same namespace, just need `curl http://service`
- In different namespaces: `curl http://service.namespace`
- For each namespace, the kubernetes service creates a subdomain, with further
subdomains for services
- The full hierarchy would follow:
  - Cluster.local (root domain)
  - Svc
  - Namespace
  - Service name
- So to access the fill service, can run: `curl http://service.namespace.svc.cluster.local`
- Note: DNS records aren't created for pods by default, though this can be enabled
(next section)
- Once enabled, records are created for pods in the DNS server, however the pod
name is rewritten, replacing the dots in the pods IP address with dashes
- Pod can then be accessed via: `curl https://<pod hostname>.namespace.pod.cluster.local`

## 9.14 - CoreDNS in Kubernetes

- How does Kubernetes implement DNS?
- Could add entries into /etc/hosts file -> not suitable for large scale
- Move to central dns server and specify the nameserver located at `/etc/resolv.conf`
- This works for services, but for pods it works differently
- Pod hostnames are the pod IP addresses rewritten with - instead of .
- Recommended DNS server = CoreDNS
- DNS Server deployed within the cluster as a pod in the kube-system namespace
- Deployed as a replicaset
- Runs the coredns executable
- Requires a config file named Corefile at `/etc/coredns/`
  - Details numerous plugins for handling errors, monitoring metrics, etc
- Cluster.local defined by kubernetes plugin
  - Options here determine whether pods have records
  - Set pods insecure -> pods secure
- Coredns config deployed as configmap -> edit this to make changes
- Kube-DNS deployed as a service by default, IP address configured as the
nameserver of the pod
- IP address to look at for DNS server configured via Kubelet.

## 9.15 - Ingress

- To understand the importance of Ingress, consider the following example:
  - Suppose you build an application into a Docker image and deploy it as a pod via Kubernetes.
  - Due to the application's nature, set up a MySQL database and deploy a clusterIP service -> allows app-database communications.
- To expose the app or external access, one needs to create a NodePort service.
  - App can then be accessed via the Node's IP and the port defined.
- To access the URL, users need to go to `http://<node ip>:<node port>`
- This is fine for small non-production apps, it should be noted that as demand increases, the replicaSet and service configuration can be altered to support load balancing.

- For production, users wouldn't want to have to enter an IP and port number every time, typically a DNS entry would be created to map to the port and IP.
- As service node ports can only allocate high numbered ports (`> 30000`):
  - Introduce a proxy server between DNS cluster and point it to the DNS server.

- The above steps are applicable if hosting an app in an on-premise datacenter.
- If working with a public cloud application, NodePort can be replaced by `LoadBalancer`
  - Kubernetes still performs NodePort's functionality AND sends an additional request to the platform to provision a network load balancer.

- The cloud platform automatically deploys a load balancer configured to route traffic to the service ports of all the nodes.

- The cloud provider's load balancer would have its own external IP
  - User request access via this IP.

- Suppose as the application grows and a new service is to be added, it's to be accessed via a new URL.
  - For the new application to share the cluster resource, release it as a separate deployment.
  - Engineers could create a new load balancer for this app, monitoring a new port
    - Kubernetes automatically configures a new load balancer on the cloud platform of a new IP.

- To map the URLs between the 2 new services, one would have to implement a new proxy server on top of those associated with the service.
  - This proxy service would have to be configured and SSL communications would have to be enabled.

- This final proxy could be configured on a team-by-team basis, however would likely lead to issues.

---

- The whole process outlined above has issues, on top of having additional proxies to manage per service, one must also consider:
  - **Cost:** Each additional Load Balancer adds more expense.
  - **Difficulty of Management:** For each service introduced, additional configuration is required for both firewalls and proxies
    - Different teams required as well as time and "person" power.

- To work around this and collectively manage all these aspects within the cluster, one can use Kubernetes Ingress:
  - Allows users access via a single URL
  - URL can be configured to route different services depending on the URL paths.
  - SSL security may automatically be implemented via Ingress
  - Ingress can act as a layer 7 load balancer built-in to Kubernetes clusters
    - Can be configured to act like a normal Kubernetes Object.

- **Note:** Even with Ingress in place, one still needs to expose the application via a NodePort or Load Balancer -> this would be a 1-time configuration.

- Once exposed, all load balancing authenticaiton, SSL and URL routing configrations are manageable and viewable via an Ingress Cotnroller.

- Ingress controllers aren't set up by default in Kubernetes, example solutions that can be deployed include:
  - GCE
  - NGINX
  - Traefik

- Load balancers aren't the only component of an Ingress controller, additionaly functionalities are available for monitoring the cluster for new Ingress resources or definitions.

- To create, write a definition file:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      containers:
      - name: nginx-ingress-controller
        image: <nginx ingress controller url>
        args:
        - /nginx-ingress-controller
        - --configmap=$(POD_NAMESPACE)/nginx-configuration
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        ports:
        - name: http
          containerPort: 80
        - name: https
          containerPort: 443
```

- **Note:** As working with Nginx, need to configure options such as log paths, SSL settings, etc.
  - To decouple this from the controller image, write a separate config map definition file to be referenced:
    - Allows easier modification rather than editing one huge file.

- An ingress service definition file is also required to support external communicationL

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```

- The service NodePort definition above links the service to the deployment.

- As mentioned, Ingress controllers have additional functionality available for monitoring the cluster for ingress resources, and apply configurations when changes are made

- For the controller to do this, a service account must be associated with it:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
```

- The service account must have the correct roles and role-bindings to work.

- To summarise, for an ingress controller, the following resources are needed:
  - Deployment
  - Service
  - ConfigMap
  - ServiceAccount

- Once an ingress controller is in place, one can create ingress resources:
  - Ingress resources are a set of rules and configurations applied to an ingress controller, linking it to other Kubernetes objects.

- For example, one could configure a rule to forward all traffic to one application, or to a different set of applications based on a URL.
- Alternatively, could route based on DNS.
  - As per, ingress resources are configured via a destination file

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-cluster
spec:
  backend:
    serviceName: wear-service
    servicePort: 80
```

- **Note:** For a single backend like above, no additional rules are required.
- The ingress resource can be created via standard means i.e. `kubectl create -f ....`

- To view ingress resource: `kubectl get ingress`
- To route traffic in a conditional form, use ingress rules e.g. routing based on DNS
- Within each rule, can configure additional paths to route to additional services or applications.

- To implement, adhere to the principles outlined in the following 2-service example:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-cluster
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
            serviceName: wear-service
            servicePort: 80
      - path: /watch
        backend:
            serviceName: watch-service
            servicePort: 80
```

- Create the ingress resource using `kubectl create -f ...` as per usual.

- To view the ingress's detailed information: `kubectl describe ingress <ingress name>`

- **Note:** In the description, a default backend is described. <br> In the event a user enters a path not matching any of the rules, they will be redirected to that backend service (which must exist!).

- If wanting to split traffic via domain name, a definition file can be filled out as normal, but in the spec, the rules can be updated to point to specific hosts instead of paths:

```yaml
...
rules:
- host: <url 1>
  http:
    paths:
    - backend:
        serviceName: <service name 1>
        servicePort: <port 1>
- host: <url 2>
  http:
    paths:
    - backend:
        serviceName: <service name 2>
        servicePort: <port 2>
...
```

- When splitting by URL, had 1 rule and split the traffic by 2 paths
- When splitting by hostname, used 2 rules with a path for each.

- **Note:** If not specifying the host field, it'll assume it to be a `*` and / or accept all incoming traffic without matching the hostname
  - Acceptable for a single backend
