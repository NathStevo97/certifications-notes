# 3.27 - Securing the Docker Daemon

- The Docker Daemon / Engine / API Service needs to be secured appropriately, otherwise unauthorized users could:
  - Delete existing containers hosting applications
  - Delete volumes storing data
  - Run containers of their own e.g. bitcoin mining
  - Gain root access to the host system via a privileged container
    - Can lead to targeting of other systems in the infrastructure
- **Reminder:**
  - The Docker Daemon is by default exposed on the host only on a UNIX socket at `/var/run/docker.sock`
  - No one outside of the host can access the docker daemon by default
  - **Note:** The applications can still be accessed so long as the ports are published
- First Area of Security Consideration - Host:
  - Actions that can be taken include:
    - Disable Password-based authentication
    - Enable SSH key-based authentication
    - Determine which users need access to the servers
    - Disabling unused ports
  - External access needs to be configured only if absolutely necessary - achievable by adding to the "hosts" array in the docker daemon json configuration file.
    - Any hosts added must be private and only accessible within your organisation
    - TLS Certificates must also be configured for the server in this scenario, requiring:
      - A certificate authority
      - A TLS certificate
      - A TLS Key
    - TLS Configuration requires setting the port value for hosts in the config file to 2376 for encrypted TLS communication; as well as tls = true.
    - On the host accessing the docker daemon, the following must also be set as environment variables:
      - `DOCKER_TLS=true`
      - `DOCKER_HOST="tcp://<IP>:2376"`
- The configurations so far are acceptable but no authentication is enforced. To do so, certificate-based authentication can be enabled by copying the certificate authority to the docker daemon server.
  - The docker daemon config file can have the following added:
    - `tlsverify = true` - enforces the need for clients to authenticate
    - `tlsecacert = "path/to/cacert.pem"`
- To authenticate, clients need to have their own certificates signed by the CA, generated to give client.pem and clientkey.pem
  - Sharing these with the cacert on the host
- On the client side, these can be passed via `--tlscert`, `--tlskey`, `--tlscacert` flags or added to the `./docker` folder on the system.
- **Summary:**
  - TLS alone only enforces encryption, TLS verify enforces authentication

![Docker TLS Comparison](./img/docker-tls.png)
