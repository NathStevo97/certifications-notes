# 3.1 - Prerequisites: Commands and Arguments in Docker

- **Note:** This is not a requirement for the CKAN curriculum.

- Consider a simple scenario:
  - Run a docker container via an ubuntu image: `docker run ubuntu`
  - Runs an instance of the Ubuntu image and exits immediately, noted upon execution of `docker ps -a`

- This occurs beause containers aren't designed to host an OS, but instead to run a specific task or process.
  - Example: host a web server or database
  - So long as that process stays active, so does the container.
  - If the service stops or crashes, the container exits.

- A Dockerfile with `CMD ["bash"]` defined doesn't work as this is not a command, but a CLI instead.
  - When the container runs, it runs Ubuntu and launches bash
- In general, Docker doesn't attach a terminal to a container when it's ran.
  - Bash cannot find a terminal and the container exits as the process finishes/fails.

- To solve, one can append commands to the `docker run` command e.g. <br> `docker run ubuntu sleep 5`

- Similarly, in a Dockerfile <br> `CMD <command> <param1>` <br> or in JSON: <br> `CMD ["command", "parameter"]`

- To build new image and run: `docker build -t <image name> .`
- To run: `docker run <image name>`

- To use the command but with a parameter value subject to change, change `CMD` to `ENTRYPOINT` i.e.: <br> `ENTRYPOINT ["command"]`
  - Any parameters specified on the CLI will automatically be appended to the entrypoint command.

- If using entrpoint and a command parameter isn't specified, an error is likely to occur, a default value should therefore be provided.
  - Therefore, `ENTRYPOINT` and `CMD` should be used together.

- Example:

```dockerfile
ENTRYPOINT ["command"]

CMD ["parameter"]
```

- From this configuration, if no additional parameter(s) is provided, the `CMD` parameter will be provided.
- Any parameter on the CLI will override the `CMD` parameter

- To override the entrypoint: `docker run --entrypoint <new command> <image name>`

- Note: `ENTRYPOINT` and `CMD` values should be expressed in a JSON format.
