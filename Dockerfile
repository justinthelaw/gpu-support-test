FROM --platform=$BUILDPLATFORM python:3.11 AS builder

ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/tmp/.venv/bin:$PATH"

USER root

WORKDIR /tmp

RUN python -m venv /tmp/.venv

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

FROM --platform=$BUILDPLATFORM python:3.11-alpine

ENV PYTHONUNBUFFERED=1
ENV PATH="/prod/.venv/bin:$PATH"

USER 1001

WORKDIR /prod

COPY main.py .
COPY LICENSE /licenses/LICENSE.txt
COPY --from=builder /tmp/.venv /prod/.venv

CMD while true; do \
    python /prod/main.py; \ 
    sleep 5; \
    done