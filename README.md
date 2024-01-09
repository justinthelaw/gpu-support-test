# GPU Support Test

This is a simple repository for running a test to confirm container passthrough access to your NVIDIA, CUDA-capable GPU(s).

## Pre-Requisites

Access to GitHub and GitHub Container Registry. Please follow the [GitHub Container Registry instructions](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Docker and all of its dependencies must be installed. Python 3.11 and Python 3.11 virtual environment tools must be installed. To build and push a new version of the Docker image to the GHCR, Docker Buildx must be installed and configured correctly.

For the GPU test, a NVIDIA GPU with CUDA cores and drivers must be present. Additionally, the CUDA toolkit and NVIDIA container toolkit must be installed. Please see the [Troubleshooting](#troubleshooting) section for details.

## Usage

### Local Development Instructions

```bash
make create-venv
source .venv/bin/activate
make requirements
make test
```

### Docker Instructions

#### Build and Run Local Image

```bash
make docker-local
```

#### Run Remote Image

```bash
make docker-latest
```

#### Push New Remote Image

Pushes are automated by [the GitHub workflow](./.github/workflows/ci.yaml) on push or pull request to `main`.

Below are manual steps for pushing a new image to a registry like GHCR using Docker. The comments above lines with environment variables are example values.

```bash
# create buildx instance
docker buildx install
# BUILDX_INSTANCE=multi-platform
docker buildx create --use --name ${BUILDX_INSTANCE}

# login to ghcr
docker login ghcr.io

# build and push multi-platform image
docker buildx build --push \
# REGISTRY=ghcr.io/justinthelaw/gpu-support-test
--build-arg REGISTRY=${REGISTRY}  \
# VERSION=0.0.1
--build-arg VERSION=${VERSION} \
--platform linux/386,windows/amd64,windows/arm64,linux/arm/v7,linux/arm/v6,linux/arm/v5,linux/arm64,linux/ppc64ie,linux/s390x,linux/amd64,linux/amd64/v2,linux/amd64/v3 \
-t ${REGISTRY}:${VERSION} .

# remove buildx instance
# BUILDX_INSTANCE=multi-platform
docker buildx rm ${BUILDX_INSTANCE}
```

## Troubleshooting

Look at the instructions on the following websites to troubleshoot:

1. Prepare your machine for NVIDIA Driver installation: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
2. Install the proper NVIDIA Drivers: https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#pre-install
3. Find the correct CUDA for your environment: https://developer.nvidia.com/cuda-downloads
4. Install CUDA properly: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
5. Docker GPU accessibility: https://docs.docker.com/config/containers/resource_constraints/#gpu
