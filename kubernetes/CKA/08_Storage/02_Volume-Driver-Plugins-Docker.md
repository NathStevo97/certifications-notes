# 8.2 - Volume Driver Plugins in Docker

- Default volume driver plugin = local
- Alternatives available include:
  - Azure File Storage
  - GCE-Docker
  - VMware vSphere Storage
  - Convoy
- To specify the volume driver, append `--volume-driver <drivername>` to the `docker run` command