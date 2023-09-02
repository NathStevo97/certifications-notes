# 5.2 - Commands and Arguments - Docker

- Note: This isn't a requirement for the CKAD/CKA curriculum
- Consider a simple scenario:
  - Run an ubuntu image with Docker: `docker run ubuntu`
  - This runs an instance of the Ubuntu image and exits immediately
- If `docker ps -a` is ran to list the containers, it won't appear
  - Due to the fact that containers aren't designed to host an OS
  - They're instead designed to run a specific task/process e.g. host a web server
  - The container will exist as long as the hosted process is active, if the service is
stopped or crashes, the container exits
- The Dockerfile's CMD section was set as `"bash"`
  - This isn't a command, but a CLI instead
  - When the container ran, Docker created a container based on the Ubuntu
image and launched bash
- Note: By default, Docker doesn't attach a terminal to a container when it's ran
  - Bash cannot find a terminal
  - Container exits as the process is finished
- To solve a situation like this, you can add container commands to the docker run
command, e.g.
  - `docker run ubuntu sleep 5`
- These changes can be made permanent via editing the Docker file either in a:
  - Shell format: `CMD command param1`
  - JSON format: `CMD ["command", "param1"]`
- To build the new image, run: `docker build -t image_name .`
- Run the new image via `docker run <image_name>`
- To use a command but with a different value of parameter to change each time,
change the `CMD` to `"ENTRYPOINT"` i.e. `ENTRYPOINT ["command"]`
- Any parameters specified on the CLI will automatically be appended to the
entrypoint command
- If using entrypoint and a command parameter isn't specified, an error is likely
  - A default value should be specified
- To overcome the problem, use a combination of entrypoints and command in a
JSON format i.e.:
  - `ENTRYPOINT ["command"]`
  - `CMD ["parameter"]`
- From this configuration, if no additional parameter is provided, the CMD parameter
will be applied
- Any parameter on the CLI will override the CMD parameter
- To override the entrypoint command, run:
  - `docker run --entrypoint <new command> <image name>`