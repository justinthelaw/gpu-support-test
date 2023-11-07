# NEEDS TO BE UPDATED AFTER THE FOLLOWING

1. Cut release tags for all components
2. Build and push docker images up to GHCR
3. Create Zarf packages
4. Deploy Zarf packages to LF-04
5. Push Zarf packages up to GHCR

---

# LeapfrogAI Installation - CPU Inferencing for Transcription and Summarization

This example installation set will cover the CPU-based inferencing Transcription and Summarization use-case. The instructions are just a set of commands that must be executed to properly get the use-case upa nd running.

This is an opinionated installation instruction set. All other methods, to include delivery to an air-gap (controlled ingress and egress network), are not supported by this instruction set. For specific needs or use-cases, please go to https://leapfrog.ai/ for support or submit an issue at https://github.com/defenseunicorns/leapfrogai.

## Assumptions

The following assumptions are being made for the writing of these installation steps:

- User has a Unix-based operating system with `sudo` access
  - Commands may need to be modified based on specific distribution
  - Instruction commands were executed in an Ubuntu 22.04 LTS terminal
- User has a machine with at least the following minimum specifications:
  - CPU with at least 6 cores @ 2.70 GHz
  - RAM with at least 64 GB free memory
  - Storage with at least 128 GB free space

## Instructions

The following steps and commands must be executed in the order they are presented. "root folder" means the base folder where you are storing all the project dependencies.

### 1. Install Tools

#### Docker Engine

```bash
sudo apt install docker-ce
```

#### Zarf

```bash
wget https://github.com/defenseunicorns/zarf/releases/download/v0.31.0/zarf_v0.31.0_Linux_amd64
mv zarf_v0.30.1_Linux_amd64 /usr/local/bin/zarf
chmod +x /usr/local/bin/zarf
```

#### Kubectl

```bash
sudo apt install kubectl
```

#### K3d

```bash
sudo apt install k3d
```

### 2. K3d Cluster

```bash
git clone https://github.com/defenseunicorns/uds-package-dubbd.git
cd uds-package-dubbd/k3d/local # from root folder
zarf package create --confirm
zarf package deploy --confirm zarf-package-k3d-local-*.tar.zst
```

### 3. DUBBD

```bash
cd ../ # into uds-package-dubbd/k3d/ folder
docker login registry1.dso.mil # account creation is required
zarf package create --confirm
zarf package deploy --confirm zarf-package-dubbd-*.tar.zst
```

### 4. LeapfrogAI

```bash
cd ../../ # into root folder
git clone https://github.com/defenseunicorns/leapfrogai.git
cd leapfrogai
git checkout 223-k8s-networking-updates-whisper-jlaw
zarf package create --confirm
zarf package deploy zarf-package-leapfrogai-*.zst --confirm
```

### 5. Whisper Model

```bash
cd ../ # into root folder
git clone https://github.com/defenseunicorns/leapfrogai-backend-whisper.git
cd leapfrogai-backend-whisper # into leapfrogai-backend-whisper folder
docker build -t ghcr.io/defenseunicorns/leapfrogai/whisper:0.0.1 .
zarf package create --confirm
zarf package deploy zarf-package-whisper-*.tar.zst
```

### 6. CTransformers

```bash
cd ../ # into root folder
git clone https://github.com/defenseunicorns/leapfrogai-backend-ctransformers.git
cd leapfrogai-backend-ctransformers # into leapfrogai-backend-ctransformers folder
docker build -t ghcr.io/defenseunicorns/leapfrogai/ctransformers:0.0.2 .
zarf package create --confirm
zarf package deploy zarf-package-ctransformers-*.tar.zst
```

### 8. Doug Translate

```bash
cd ../ # into root folder
git clone https://github.com/defenseunicorns/doug-translate.git
cd doug-translate # into doug-translate folder
docker build . -t defenseunicorns/doug-translate:0.0.1
git checkout fix-dubbd-lfai-zarf-deployment
zarf package create -o pkgs --confirm
zarf package deploy pkgs/zarf-package-doug-translate-amd64-0.0.1.tar.zst --confirm
```

#### 9. Setup Access

If using the https://doug-translate.bigbang.dev URL as your frontend access point:

```bash
# opens k9s
zarf tools monitor
# go to services by typing the following and pressing ENTER
:services
# take note of the External IP of istio-service/tenant
# use Ctrl+C to exit k9s
sudo vim /etc/hosts
# add the following line, where <IP_ADDRESS> is the External IP of istio-service/tenant:
# <IP_ADDRESS>    leapfrogai.leapfrogai.bigbang.dev    doug-translate.bigbang.dev
```

If using the the Istio System Tenant Gateway IP address (e.g., https://172.18.255.1) as your frontend access point:

```bash
# opens k9s
zarf tools monitor
# go to gateways by typing the following and pressing ENTER
:gateways
# highlight istio-system/tenant and press E to edit the
e
# press I to insert in VIM
# modify any hosts that have a value of "*bigbang.dev" to be "*"
# press ESC then type ":wq" and press ENTER
```

#### 10. Test API

```bash
# test API
curl --location --insecure 'https://leapfrogai.leapfrogai.bigbang.dev/openai/v1/models'
# test installed model
curl --location --insecure 'https://leapfrogai.leapfrogai.bigbang.dev/openai/v1/completions' \
--header 'Content-Type: application/json' \
--data '{"model":"ctransformers",
"prompt":"Who was the president in 2015?",
"temperature":1.0,
"max_tokens":1024}'
```

#### 11. Access Frontend

Go to https://doug-translate.bigbang.dev or https://<ISTIO_TENANT_IP> to upload an audio file and then generate a summary.
