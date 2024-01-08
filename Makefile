.PHONY: all

create-venv:
	python3.11 -m venv .venv

requirements:
	pip install -r requirements.txt

build-requirements:
	pip install freeze > requirements.txt

test:
	python src/main.py

docker-local:
	docker build -t gpu-support-testing . && \
	docker run --gpus all -it --rm gpu-support-testing

docker-latest:
	docker run --gpus all -it --rm ghcr.io/justinthelaw/gpu-support-testing:latest
