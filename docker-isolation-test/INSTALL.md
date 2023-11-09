# LeapfrogAI Installation - CPU Inferencing for AI Transcription and Summarization

## Zarf

The following instructions rely on Zarf to easily and quickly install all parts of the stack into a Kubernetes cluster

Deploying or updating things inside a Kubernetes cluster with Zarf is as easy as:

```bash
zarf package create --confirm
zarf package deploy --confirm
```

See https://zarf.dev/ for more details.

## Assumptions

The following assumptions are being made for the writing of these installation steps:

- User has a standard Unix-based operating system installed, with `sudo` access
  - Commands may need to be modified based on specific distribution
  - Commands were executed in an Ubuntu 22.04 LTS bash terminal
- User has a machine with at least the following minimum specifications:
  - CPU with at least 6 cores @ 2.70 GHz
  - RAM with at least 64 GB free memory
  - Storage with at least 128 GB free space
  - Minimum base software: `apt update && apt install build-essential iptables git procps jq docker.io -y`

## Instructions

The following steps and commands must be executed in the order that they are presented, top to bottom. All `cd` commands are done relative to your development environment's root folder. Assume every new step starts at the root folder.

_Note 1_: "root folder" means the base directory where you are storing all the project dependencies for this installation.

_Note 2_: 1) "Internet Access" and 2) "Isolated Network" will be noted when the instructions differ between 1) a system that can pull and execute remote dependencies from the internet, and 2) a system that is isolated and cannot reach outside networks or remote repositories.

_Note 3:_  For all "Isolated Network" installs, `wget`, `git clone` and `zarf package create` commands are assumed to have been done and stored on a removable media device. These commands are under the bash comments `download` and `create`.

_Note 4:_ For instances where you do not want to download a tagged version of a LeapfrogAI release (e.g., leapfrogai-ctransformers-backend:0.2.0), you can perform the following generic instructions prior to any of the `zarf package create` commands:

```bash
docker build -t "ghcr.io/defenseunicorns/leapfrogai/<NAME_OF_PACKAGE>:<DESIRED_TAG>" .
# do a find and replace on anything matching the official tag
# example in VSCode for: in the git directory press alt+shift+f, and search 0.2.0 and "replace all" with your DESIRED_TAG
zarf package create zarf-package-<NAME_OF_PACKAGE>-*.tar.zst
```

_Note 5:_ It may be in your best interest to perform the steps in "Note 4", as the main branches of all the LeapfrogAI branches are usually more bug-free and feature complete than our releases (we are in our infancy).

### 0. Switch to Sudo

```bash
sudo su # login as required
```

### 1. Install Tools

For each of these commands, be in the `tools/` directory.

```bash
cd tools
```

#### Zarf

```bash
# download
wget https://github.com/defenseunicorns/zarf/releases/download/v0.31.0/zarf_v0.31.0_Linux_amd64

# install
mv zarf_v0.31.0_Linux_amd64 /usr/local/bin/zarf
chmod +x /usr/local/bin/zarf

# check
zarf version
```

#### Kubectl

_Internet Access:_

```bash
apt install kubectl
```

_Isolated Network:_

```bash
# download
wget https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl

# install
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# check
kubectl version
```

#### K3d

_Internet Access:_

```bash
apt install k3d
```

_Isolated Network:_

```bash
# download
wget https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64

# install
mv k3d-linux-amd64 /usr/local/bin/k3d
chmod +x /usr/local/bin/k3d

# check
k3d version
```

### 2. Install Zarf Packages

For each of these commands, be in the `zarf-packages/` directory.

```bash
cd zarf-packages
```

#### Setup the K3d Cluster

```bash
# download
git clone https://github.com/defenseunicorns/uds-package-dubbd.git
cd uds-package-dubbd/k3d/local

# create
zarf package create --confirm

# deploy
zarf package deploy --confirm zarf-package-k3d-local-*.tar.zst
```

#### Deploy DUBBD

```bash
# create
cd uds-package-dubbd/k3d/
docker login registry1.dso.mil # account creation is required
zarf package create --confirm

# install
zarf package deploy zarf-package-dubbd-*.tar.zst --confirm
```

#### LeapfrogAI

```bash
# download
git clone https://github.com/defenseunicorns/leapfrogai-api.git
cd leapfrogai-api/

# create
zarf package create --confirm

# install
zarf package deploy zarf-package-leapfrogai-api-*.zst
# press "y" for prompt on deployment confirmation
# press "y" for prompt to create and expose new gateway for load balancer access
```

#### Whisper Model

```bash
# download
git clone https://github.com/defenseunicorns/leapfrogai-backend-whisper.git
cd leapfrogai-backend-whisper # into leapfrogai-backend-whisper folder

# create
zarf package create --confirm

# install
zarf package deploy zarf-package-whisper-*.tar.zst --confirm
```

#### CTransformers

```bash
# download
git clone https://github.com/defenseunicorns/leapfrogai-backend-ctransformers.git
cd leapfrogai-backend-ctransformers

# create
zarf package create --confirm

# install
zarf package deploy zarf-package-ctransformers-*.tar.zst --confirm
```

#### Leapfrog Transcribe

```bash
# download
git clone https://github.com/defenseunicorns/doug-translate.git
cd doug-translate

# create
zarf package create --confirm

# install
zarf package deploy zarf-package-doug-translate-amd64-0.0.1.tar.zst
# press "y" for prompt on deployment confirmation
# for "LEAPFROGAI_BASE_URL" prompt, press enter
# for "DOMAIN" prompt type "localhost:8083"
# for "SUMMARIZATION_MODEL" prompt, press enter
```

#### 3. Setup Access

```bash
k3d cluster edit dubbd --port-add "8083:30535@loadbalancer"
```

#### 4. Test Access

Go to https://localhost:8083 to hit the Leapfrog Transcribe frontend web application.

## Disclaimers

The stack as it currently stands (Nov 2023) is a free prototype. The list below contains all of the possible issues you may run into as you use this to transcribe and summarize meetings.

- It cannot gracefully (slow or clashing request handling) handle concurrent users, so 1 user at a time is recommended if no replica sets are created
- Transcription and summarization workflow for a dense, 1-hour audio takes anywhere between 10-20 minutes depending on CPU and RAM
- Transcription and summarization accuracy worsens for audio longer than 30 minutes on whisper-base
    - Transcription accuracy is around 97% for audio between 5-20 minutes, and goes down to 70-95% for audio shorter or longer than 5-20 minutes
    - See the following for some transcription benchmarking details: https://github.com/defenseunicorns/whisper-benchmarking
    - Summarization has not been benchmarked, and the batching/concatenation method is experimental
