# GPU Support Test

This is a simple repository for running a test to confirm the environment has container or pod passthrough access to your NVIDIA, CUDA-capable GPU(s).

## Pre-Requisites

Access to GitHub and GitHub Container Registry. Please follow the [GitHub Container Registry instructions](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Docker and all of its dependencies must be installed. Python 3.11 and Python 3.11 virtual environment tools must be installed. To build and push a new version of the Docker image to the GHCR, Docker Buildx must be installed and configured correctly.

For the container GPU test, a NVIDIA GPU with CUDA cores and drivers must be present. Additionally, the CUDA toolkit and NVIDIA container toolkit must be installed. Please see the [Troubleshooting](#troubleshooting) section for details.

For Kubernetes testing and pre-requisites, please see [Kubernetes Deployment](#kubernetes-deployment) for details.

## Usage

### Local Development Instructions

_*NOTE*_: Use `Ctrl-C` or a equivalent SIGTERM to end the looped test.

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

Pushes are automated by [the GitHub workflow](./.github/workflows/build-and-push-image.yaml) on push or pull request to `main`.

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

### Kubernetes Deployment

The following instructions assumes that you already have an existing Kubernetes cluster up and running, the Kubernetes cluster already has the NVIDIA GPU operator plugin deployed and Zarf is pointed to that cluster and the context to be tested.

During deployment, a prompt will allow you to modify the number or slices of GPUs the pod can access. See [Troubleshooting](#troubleshooting) bullet item #6 for more details.

The Kubernetes deployment of this test relies on Zarf. To package and deploy the test, execute the following:

```bash
zarf package create --confirm
zarf package deploy # follow the prompts
```

## Troubleshooting

Look at the instructions on the following websites to troubleshoot:

1. Prepare your machine for NVIDIA Driver installation: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
2. Install the proper NVIDIA Drivers: https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#pre-install
3. Find the correct CUDA for your environment: https://developer.nvidia.com/cuda-downloads
4. Install CUDA properly: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
5. Docker GPU accessibility: https://docs.docker.com/config/containers/resource_constraints/#gpu
6. NVIDIA GPU operator: https://github.com/NVIDIA/k8s-device-plugin
