import torch

print("Commencing GPU availability test...\n")

cuda_available = torch.cuda.is_available()
if cuda_available:
    print("GPU(s) are accessible to this container! See list of available devices below:")
    device_count = torch.cuda.device_count()
    for device in range(device_count):
        print(f"\tDevice #{device}: {torch.cuda.get_device_name(device)}")
else:
    print("GPU(s) are NOT accessible to this container!")

print("\nGPU availability test has ended.")
