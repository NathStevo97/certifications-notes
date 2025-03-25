# 9.1 - Define, Build, and Modify Container Images

- When containerising an application, the image would typically follow the steps used to run the application locally e.g.:
  - Define the OS / Base Image
  - Install dependencies
  - Setup source code
  - Initialise the App

- An example follows for a sample Flask application:

```Dockerfile
FROM ubuntu

RUN apt-get update
RUN apt-get install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```

- The image can then be built locally: `docker build Dockerfole -t <dockerhub Username>/<image name>`
- The image can then be pushed to Dockerhub `docker push <dockerhub username>/<image name>`

- The instructions defined in a Dockerfile are viewed as layered architecture, each layer only stores the changes defined from the previous. This is viewed during the Docker build as steps e.g. step 3/5.

- Each layer is cached by Docker, in the event of step failure, it will continue from the last working step once the issue is fixed. This saves time when building images.
