import torch

print("Commencing CUDA and GPU availability test...\n")

cuda_available = torch.cuda.is_available()
if cuda_available:
    print("CUDA is accessible to this container! See list of available devices below:")
    device_count = torch.cuda.device_count()
    for device in range(device_count):
        print(f"\tDevice #{device}: {torch.cuda.get_device_name(device)}")
else:
    print("CUDA is NOT accessible to this container!")

print("\nCUDA and GPU availability test has ended.")
