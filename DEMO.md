# Docker Basics 1 Demo

This is a demo about Docker Basics, to jump to the lesson: [DOCKER BASICS LESSON](LESSON.md)

## Pre-Requisites:

* Docker Desktop(MacOS and Windows) or Docker Engine(Linux) installed on your host( your computer).
* Python 3
* Knowledge of using a terminal.
* A Code Editor
* Demo will be with Linux Operating System (Ubuntu 20.04)

## Docker commands needed for this demo:

* `docker container ls` lists all running docker containers
* `docker container run <IMAGE_NAME>:<IMAGE_VERSION>` runs a container with a specific image
    * `-i` Keep STDIN open even if not attached
    * `-d` Detaches; allows the container to run in the background.
    * `-t` Allocate a pseudo-TTY (which allows that container to be kept alive even without an app running)
    * `-p <HOST_PORT>:<CONTAINER_PORT>` publishes a port on the host machine to the container. Allows communications between the host machine and container on a specific port.
* `docker container kill <CONTAINER_IDENTIFIER>` kills a docker container by specifying name or ID for a container.
* `docker start <CONTAINER_IDENTIFIER>` runs a stopped docker container.
    * `-a` attaches container to current terminal
    * `-i` allows current terminal to interact with the container
* `docker commit <CONTAINER_IDENTIFIER> <NEW_IMAGE_NAME>` saves the state of a container as a new image.
* `docker images` list docker images on your host machine.
* `docker build <PATH_TO_DOCKERFILE>` builds an image using a Dockerfile as a template.
    * `-t` sets a tag (label/name) for the image built from the Dockerfile

## Python Server

Creating a python web server, save the below code to a file named `server.py`

[code can be found here](https://github.com/daniel-lee-tech/docker-basics-1/blob/main/server.py)

```python
from http.server import BaseHTTPRequestHandler, HTTPServer

# hostName CAN NOT BE LOCALHOST, it will not work in docker containers.
hostName = "0.0.0.0" 
serverPort = 8080

class MyWebServer(BaseHTTPRequestHandler):
   def do_GET(self):
       self.send_response(200)
       self.send_header("Content-type", "text/html")
       self.end_headers()
       self.wfile.write(bytes("<p>Simple web server from python</p>", "utf-8"))


if __name__ == "__main__":
   webServer = HTTPServer((hostName, serverPort), MyWebServer)
   print("server started at host: " + hostName + " on port: " + str(serverPort))

   try:
       webServer.serve_forever()
   except KeyboardInterrupt:
       webServer.server_close()
       print("Server stopped.")
```

Let's make sure that this python server works before we dockerize it.

We can run this server by:

```bash
cd <FOLDER_WHERE_SERVER_EXISTS>
python3 server.py
```

If we open the browser and navigate to `localhost:8080` you should be able to see `Simple web server from python` on the page.

Once we know it works on our host, we can dockerize this app so it can run anywhere a linux docker container can run.

## Basic Docker Linux Container

Containers are just instances of images. Docker has an image library that can give us pre built images. This image library can be accessed through [Docker Hub](https://hub.docker.com/).

### Pulling an ubuntu image and running it

Docker Hub has an official `ubuntu` image. We can run this container with an `ubuntu` image like so:

```bash
docker container run ubuntu:latest
```

When you first run this command on your machine, docker will pull the assets needed from the web to run this image on your machine. Your terminal should look something like this:

![pulling ubuntu image](/images/pulling_ubuntu_image.png)

By now you should also notice nothing really happens after pulling the image.

By default containers stop running unless there is some "keep-alive" mechanism or some app running on the container.

To list all the running containers on your host machine, you can use this command:

```bash
docker container ls
```

And you will see no running containers.

To make sure our `ubuntu` container stays running we can modify our command with a `-t` option argument. This `-t` option creates a "pseudo-tty". This tricks bash into continuing to run indefinitely because it thinks it is connected to an interactive TTY.

We also want to add the `-i` argument which allows us to interact with the "pseudo-tty". This is also needed be able to stop the container without opening a new terminal window.

```bash
# running ubuntu image without auto stopping
docker container run -it ubuntu:latest
```

After you run this command, you will notice a slight change in your terminal. 

The docker container is now running in the foreground and you are able to run commands in this linux container. After all, this is just `ubuntu` and you can do anything you want `ubuntu` to do.

You can exit this container terminal window by typing with `exit`.

If we now do:

```bash
docker container ls
```

we see one running container in the background.

We can stop this running container by doing this command:

```bash
docker container kill <CONTAINER_ID>
## OR ####
docker container kill <CONTAINER_NAME>
```

The `docker container kill` method can accept either an ID or NAME to kill a specific container. You can view the names or IDs of your containers by running `docker container ls`.

Let's kill this container and re-run this container.

DO NOT USE THIS COMMAND: 

```bash
# creates brand new container with ubuntu image
docker container run -it ubuntu:latest
```

to start your old container, this command will create a brand new container.

Use this command instead (make sure the container identifier is the same one you used in your kill command):

```bash
docker start <CONTAINER_IDENTIFIER>
```

## Creating a python server in our container

Once our container is up an running, let's update and download some dependencies.

```bash
# update and install python3 and vim
apt update && apt install python3 vim -y
```

`Vim` is a terminal text editor that will allow us to write code within our container.

Let's copy and paste a `server.py` in our container's home folder.

```bash
cd
vim server.py
# THEN COPY AND PASTE the code with CTRL + SHIFT + V
```

After you copy and pasted your code, exit vim by typing this in your keyboard:

```bash
:wq!
```

Now we can run our server in our container, (kind of):

```bash
python3 server.py
```

The python server is running but it is in an isolated process within our container. There's no way to access it, you can check by pulling up your browser and going to `localhost:8080`.

## Publishing Ports on our Container

To make our container accessible within our host machine, we have to "publish" a port on our host machine that aligns with our container. By default docker does NOT publish any ports.

The best way to do this is to stop and kill our container and rerun the container with a published port.

1. stop our python server by pressing CTRL + C.

2. let's exit our container by typing `exit`. This should exit also stop our container but if not:

3. let's kill container if it is still running (most probably not):

```bash
docker container kill <CONTAINER_IDENTIFIER>
```
4. Let's "commit" our container. This saves the state of a container and creates an image for this container.

The `<NEW_IMAGE_NAME>` I will be using `python_server`.

```bash
docker commit <CONTAINER_IDENTIFIER> <NEW_IMAGE_NAME>
```

5. You will see that your commit was successful when you see your new committed image after running:

```bash
docker images
```

6. Now you will run a NEW container instance with the custom image but specifying a published port. This can be done like so:

```bash
docker container run -i -t -p <HOST_PORT>:<CONTAINER_PORT> <CUSTOM_IMAGE_NAME>

# concrete example
docker container run -i -t -p 8080:8080 python_server
```

7. This should open your container in the foreground of your terminal, remember that our python app exists in our home folder, so to run our server we do this:

```bash
cd
python3 server.py
```

8. With our ports published, our browser on our host machine should be able to reach our python app in the container.

## Standardizing our process with a Dockerfile

Commiting modifications to our containers as images are not the best practice. There are many reasons why we should use Dockerfiles instead of commiting changes to container states as new images. These reasons include:

1. Dockerfiles makes it very apparent what changes happened to the base image.
2. Dockerfiles can be modified to change the initial build process.
3. Dockerfiles are easier to debug when your containers have bugs due to the state and build process of the container.
4. In multi-image / multi-container app environments, Dockerfiles are a lot easier to work with.
5. Dockerfiles enable dynamic changes to our app on our host machines instead of modifying app code directly in our containers through terminal windows.

## Writing our Dockerfile

FIRST Stop all your Docker process on port 8080, if there is one.

```bash
docker kill <CONTAINER_RUNNING_ON_PORT_8080>
```

Let's first create a folder that will hold our Dockerfile and our app code.

```bash
mkdir <FOLDER_NAME>
touch Dockerfile
```

and make sure you move `server.py` to this folder as well.

The contents of our Dockerfile will look like this:

```Dockerfile
# the FROM command allows us to build on top of a "base image".
# it serves as a "starting point" for our container modifications.
# building from base image ubuntu
FROM ubuntu:latest

# RUN allows us to run commands in the container terminal
# notice these RUN commands are just simple linux commands
# installing dependencies
RUN apt-get update
RUN apt install python3 -y

# COPY allows us to copy files from our host to container
# COPY <HOST_FILES> <CONTAINER_DESTINATION_PATH>
# copying app from host to container
COPY ./server.py /

# the CMD keyword determintes what will be run when this Dockerfile is ran.
# running these commands on `docker run` command
CMD python3 server.py

# The EXPOSE instruction does not actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container
EXPOSE 8080
```
## Building and Running our Dockerfile

### Building

Once we've written our Dockerfile, we have to build this as an image that can be ran on our host machines.

```bash
cd <PATH_TO_FOLDER_THAT_HOLDS_DOCKERFILE>
docker build . -t <CUSTOM_IMAGE_NAME>:<VERSION>

# concrete example
cd ~/Repos/teaching/docker-basics-1
docker build . -t dockerfile_python:1
```

This runs the instructions found in our Dockerfile but does NOT run the container.

It saves the image on your local machine and this can be see when we run:

```bash
docker images
```

### Running

We can now run our image like so:

```bash
docker container run -p <HOST_PORT>:<CONTAINER_PORT> <CUSTOM_IMAGE_NAME>

# concrete example
docker container run -p 8080:8080 dockerfile_python:1
```

*BUT*

This locks up our terminal, USE THIS command instead:

```bash
docker container run -d -p <HOST_PORT>:<CONTAINER_PORT> <CUSTOM_IMAGE_NAME>

# concrete example
docker container run -d -p 8080:8080 dockerfile_python:1
```

We can now access our python web server through our browser at `localhost:8080`.

### Editing our app

What do we do if we want to make edits to our application code or add new features?

We can just edit our `server.py` and rebuild our docker image.

Let's see this in action.

Modify the HTML present in your `server.py` on the last line of the `do_GET` method in the `MyWebServer` class.

Once we have our changes, let's kill our container.

```bash
docker kill <CONTAINER_RUNNING_ON_PORT_8080>
```

Let's rebuild our Dockerfile, our Dockerfile transfers over the updated `server.py` from the host to our container.

```bash
docker build . -t <CUSTOM_IMAGE_NAME>:<VERSION>

# concrete example
docker build . -t dockerfile_python:2 # notice the updated version number
```

Now run the updated build

```bash
docker container run -d -p <HOST_PORT>:<CONTAINER_PORT> <CUSTOM_IMAGE_NAME>

# concrete example
docker container run -d -p 8080:8080 dockerfile_python:2 # notice the updated version number
```

And voila! Opening `localhost:8080` will reflect the new changes.
