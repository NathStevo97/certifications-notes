# 3.26 - Docker Service Configuration

- Docker service can be managed via the systemctl command:
  - **Start** - start the service
  - **Status** - check the service status
  - **Stop** - stop the service
- The Docker Daemon can be started manually via running dockerd
  - Usually done for troubleshooting or debugging purposes
  - Prints dockerd logs
  - Additional logs printable via the `--debug` flag
- The docker daemon starts and listens on an internal unix socket at `/var/run/docker.sock`
  - Unix Socket = Inter-Process Communication (IPC) mechanism used for
communication between different processes on the same host
  - Implies the docker daemon is only intractable within the same host and docker CLI is only configured to interact with the docker daemon on this host.
- In the event you want to establish connection to the docker daemon from another host running the Docker CLI e.g. a Cloud VM running docker daemon.
  - Not set up by default.
  - One can instruct the daemon to listen on a TCP interface by adding a flag to the dockerd command: `--host=tcp://<IP>:2375`
  - The host at IP can now interact with the Docker Daemon using the Docker CLI, first by setting the environment variable `DOCKER_HOST="tcp://<IP>:2375"`
  - **Note:** This is disabled by default - For good reason! This is because by making the API server available on the internet, anyone can create and manage containers on the Daemon host - no security is set up by default.
  - Docker Daemon sets unencrypted communication by default, to set:
    - Create a pair of TLS certificates
    - Add the following flags to the dockerd command:
      - `--tls=true`
      - `--tlscert=/var/docker/server.pem` (path to certificate)
      - `--tlskey=/var/docker/serverkey.pem `(path to private key)
  - With TLS enabled, the standard port becomes 2376 - encrypted traffic; 2375 remains for unencrypted traffic.
- All the options specified in this section can be added to a configuration file for ease of use; typically located at `/etc/docker/daemon.json`
  - This must be created if it doesn't already exist; it's not included by default
  - Note: Hosts is an array i.e. `["host 1", "host 2", .... ]`
  - This configuration can be referenced when using the systemctl utility to start the Docker server.