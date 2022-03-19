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