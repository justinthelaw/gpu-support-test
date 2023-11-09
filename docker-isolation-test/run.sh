#! /bin/bash

docker build -t airgap-ubuntu-2204 . && \

docker run -it \
  --memory=64g \
  --gpus device=0 \
  -v volume:/container/storage \
  --shm-size=128g \
  --network=none \
  airgap-ubuntu-2204