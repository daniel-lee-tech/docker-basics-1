# Docker Basics 1 Lesson

This is a lesson about Docker Basics, to jump to the demo: [DEMO INSTRUCTIONS](DEMO.md)


## What is Docker?

Docker is a tool for creating containers.

Containers are isolated bundles of code, assets, and binaries to run your apps.

These isolated bundles can be "templated" and these templates are called “images”.

For more info:
https://docs.docker.com/get-started/overview/

## Docker vs Virtual Machines
* If you already know about virtual machines:
    * Containers are like virtual machines but instead of virtualizing a whole new operating system, containers virtualize your application logic.
    * This can be done because containers are run on an engine on top of the host operating system and this engine can utilize the resources of the host operating system.
        * Which is why containers are OS-Specific. 
            * Windows containers can only run on Windows OS’ 
            * Linux containers can only run on Linux OS’.

## What are Docker images?
* Images are analogous to templates for containers.
* For programmers:
    * Images are like classes and containers are the instances/objects of those classes.
* For IT professionals:
    * Images are like snapshots for virtual machines.
* Images are created by Dockerfiles.
    * Dockerfiles are analogous to scripts. Docker will follow the instructions of these Dockerfiles to create containers.

## Why Docker / Containers ?
* ### Cheaper:
    * Before virtualization, containers, and cloud, companies had to buy new servers for each new application.
    * Containers allow you utilize a host machine to the fullest by creating isolated app instances on one host machine.
    * Allows for easier and predictable horizontal scaling strategies.
* ### Portable and Consistent:
    * Containers consist of a “image” which is like a template of how to instantiate your container the same way across many different instances.
    * The consistency of how “images” behave allows teams to create a more stable and deployable environments.
    * No more “but it works on my local machine”. (for the most part). 
    * Developers only need to worry about installing Docker correctly and having the right environment configuration; instead of worrying about language versions, installing dependencies, and being on the right operating system.

* ### Abstractable:
    * Allows developer teams to create applications without worrying about the infrastructure.
    * Containers are able to create a nice separation of concerns:
        * Developers write code within containers.
        * Ops only worry about properly deploying containers.


## Demo: Dockerized Python Web Server

[DEMO INSTRUCTIONS](DEMO.md)

