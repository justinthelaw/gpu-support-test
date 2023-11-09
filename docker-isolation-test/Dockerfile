# Start with base Ubuntu 22.04 image
FROM ubuntu:22.04

# Create working directory for copy
WORKDIR /home/dev

# Pull in instructions
COPY INSTALL.md /home/dev

USER root
# should be on every operating system
RUN apt update && apt upgrade -y
RUN apt install build-essential iptables git procps jq docker -y

# Pull in binaries and Zarf packages from host at container runtime
COPY tools/ /home/dev/tools/
COPY zarf-packages/ /home/dev/zarf-packages/

# Give access to GPU when run
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility 

EXPOSE 8083:8083

# Run command
CMD [ "/bin/bash" ]