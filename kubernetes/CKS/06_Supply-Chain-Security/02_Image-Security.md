# 6.2 - Image Security

- Docker images follow the naming convention where `image: <image name>`
  - Image name = image / repository referenced
  - i.e. library/image name
    - Library = default account where docker official images are stored
    - If referencing from a particular account - swap library with account name
  - Images typically pulled from docker registry at docker.io by default
- Private repositories can also be referenced
  - Requires login via `docker login <registry name>`
  - It can then be referenced via the full path in the private registry
  - To facilitate the authentication - create a secret of type docker-registry i.e.:

`kubectl create secret docker-registry <name> --docker-server=<registry name> --docker-username=<username> --docker-password=<password> --docker-email=<email>`

Then, in the pod spec, add:

```yaml
imagePullSecrets:
- Name: <secret name>
```
