# 8.1 - Storage in Docker

- For storage in Docker, must consider both Storage and Volume Drivers.
- Docker file system setup at /var/lib/docker
  - Contains data relating to containers, images, volumes, etc.
- To ensure data in a container is stored, create a persistent volume:
  - `Docker volume create <volume>`
  - The volume can then be mounted into a container: `docker run -v data_volume:/path/to/volume <container>`
  - **Note:** if a volume hasn't been already created before this run command, docker will automatically create a volume of that name at the path specified
- For mounting a particular folder to a container, replace <data_volume> or whatever named with the full path to the folder you want to mount
- Alternative command: `--mount type=<type>,source=<source>,target=<container volume path> container`
- Operations like this, maintaining a layered architecture etc. is handled by storage
drivers such as AUFS, BTRFS, Overlay2, Device Mapper
- Docker chooses the best storage driver given the OS and application
