FROM python:3.9
WORKDIR /workspace
COPY ./gpu_test.py /workspace
RUN pip3 install torch
RUN pip3 install numpy
CMD ["python3", "gpu_test.py"]