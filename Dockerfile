# building from base image ubuntu
FROM ubuntu:latest

# installing dependencies
RUN apt-get update
RUN apt install python3 -y

# copying app from host to container
COPY ./server.py /

# running these commands on `docker run` command
CMD python3 server.py

# The EXPOSE instruction does not actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container
EXPOSE 8080
