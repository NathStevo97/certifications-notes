# 2.14 - General Tips

- When using the CLI, it can become difficult to create and edit the YAML files
associated with objects in Kubernetes
- A quick alternative is to copy and paste a template file for the designated object and
edit it as required, in Linux Distributions this can be done via:
  - `CTRL+Insert = Copy`
  - `SHIFT+Insert= = Paste`
- Alternatively, the kubectl run command can be used to generate a YAML template
which can be easily modified, though in some cases you can get away with using
kubectl run without creating a new YAML file, such as the following examples.

```shell
# Creating an NGINX Pod

kubectl run nginx --image=nginx

# Creating an NGINX Deployment

kubectl create deployment --image=nginx nginx
```

- In cases where a YAML file is needed, one can add the `--dry-run` flag to the kubectl
run command and direct its output to a YAML file
- The `--dry-run=client` flag signals to Kubernetes to not physically create the object
described, only generate a YAML template that describes the specified object

```shell
# Create an NGINX Pod YAML without Deploying the Pod

kubectl run nginx --image=nginx --dry-run=client -o yaml > nginx-pod.yaml

# Create a deployment YAML

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

# Create a deployment YAML with specific replica numbers:

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```
