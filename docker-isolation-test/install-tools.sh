#! /bin/bash

mv tools/zarf_v0.31.0_Linux_amd64 /usr/local/bin/zarf && chmod +x /usr/local/bin/zarf && zarf version

install -o root -g root -m 0755 tools/kubectl /usr/local/bin/kubectl && kubectl version

mv tools/k3d-linux-amd64 /usr/local/bin/k3d && chmod +x /usr/local/bin/k3d && k3d version