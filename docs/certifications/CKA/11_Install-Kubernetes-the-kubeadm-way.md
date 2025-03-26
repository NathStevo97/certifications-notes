# 11.0 - Install Kubernetes the Kubeadm Way

1. Decide on Configuration - Master vs Worker
2. Install a container runtime (Docker, etc.)
3. Install Kubeadm
4. Initialise the Master Node
5. Pod Network Setup
6. Join worker nodes to the master node

---

## Resources

- [Github Repo](https://github.com/kodekloudhub/certified-kubernetes-administrator-course)
- [Kubernetes Documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm)

## Deploy with Kubeadm - Provision VMs with Vagrant

- Using links above, and ensuring Virtualbox and vagrant are installed, clone the repo and run `vagrant up`
- This will pull the images for the vms defined and kubernetes, creating a kubernetes master node and 2 workers
- To access any, `vagrant ssh <vm name>` (can run commands to test things)
- Check status with `vagrant status`

## Demo - Deploy with Kubeadm

- Ssh into kubemaster: `vagrant ssh kubemaster`
- Check `br_nefilter` is deployed: `lsmod | grep br_netfilter`
  - Allows iptables to can see bridged traffic
  - Load the kernel module: `sudo modprobe br_netfilter`
  - Run the previous `lsmod` command for verification and repeat for each node.

- Load the relevant modules and iptables settings into a `k8s.conf` file:

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```

- Run the rest as sudo by default: `sudo -i`
- Install container runtime e.g. Docker via supporting documentation.
- Install kubeadm, kubectl and kubelet via supporting documentation.

- **Note:** If not using Docker as the container runtime, additional configuration may be needed for the CGroup

- Creating the cluster starts with initializing the master node: `kubadm init --pod-network-cidrs <range> --apiserver-advertise-address <masternode address>`

- Command sample: `kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.56.2`

- Install a pod network addon upon initialization e.g. Flannel, Weave, Calico; each has their own supporting documentation for this.

- Once complete, instructions are provided on how to start using the cluster, including setting the kubeconfig location and ownership.

- Worker nodes can be added to the cluster by running the provided command upon initialisation: `sudo kubeadm join .... <parameters>`
