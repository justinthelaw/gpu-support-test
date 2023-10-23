# Docker GPU Test

This is a simple repository for running a test against your docker engine to see if it has passthrough access to your CUDA GPU(s).

## Run the Test

```bash
docker build -t gpu-test .
docker run gpu-test
```

## Remove the Test

```bash
docker ps -a # grab the container ID with the tag "gpu-test"
docker remove <CONTAINER_ID> # use "docker kill <CONTAINER_ID>" as necessary
docker system prune -a -f && docker volume prune -f # OPTIONAL (removes unused containers, images, and volumes)
```

## If CUDA Isn't Available

Look at the instructions on the following websites to troubleshoot:

1. Prepare your machine for NVIDIA Driver installation: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
2. Install the proper NVIDIA Drivers: https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#pre-install
3. Find the correct CUDA for your environment: https://developer.nvidia.com/cuda-downloads
4. Install CUDA properly: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
5. Docker GPU accessibility: https://docs.docker.com/config/containers/resource_constraints/#gpu
