# Start with base Ubuntu 22.04 image
FROM ubuntu:22.04

# Create working directory for copy
WORKDIR /home/dev

# Pull in binaries and Zarf packages from host at container runtime
COPY foundational-software/ /home/dev/foundational-software/
COPY zarf-packaged-software/ /home/dev/zarf-packaged-software/

# Give access to GPU when run
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility 

# Run command
CMD [ "/bin/bash" ]