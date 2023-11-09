#! /bin/bash

docker build -t airgap-ubuntu-2204 . && \

docker run -it \
  -privilaged \
  --memory=64g \
  --gpus device=0 \
  --shm-size=128g \
  --network=none \
  -v /var/run/docker.sock:/var/run/docker.sock \
  airgap-ubuntu-2204