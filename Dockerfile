FROM python:3.11
WORKDIR /workspace
COPY ./gpu_test.py /workspace
RUN pip install torch
RUN pip install numpy
CMD ["python", "gpu_test.py"]