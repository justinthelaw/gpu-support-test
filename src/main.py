import torch
import time
import signal
import sys


def sigterm_handler(signum, frame):
    sys.exit(0)


signal.signal(signal.SIGTERM, sigterm_handler)

start_timestamp = time.strftime("%Y-%m-%d %H:%M:%S")

print(f"{start_timestamp} => Commencing GPU availability test...")

while True:
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")

    try:
        cuda_available = torch.cuda.is_available()
        if cuda_available:
            print(
                f"{timestamp} => GPU(s) are accessible to this container! See list of available devices below:"
            )
            device_count = torch.cuda.device_count()
            for device in range(device_count):
                print(
                    f"{timestamp} => \tDevice #{device}: {torch.cuda.get_device_name(device)}"
                )
        else:
            print(f"{timestamp} => GPU(s) are NOT accessible to this container!")

        time.sleep(10)

    except KeyboardInterrupt:
        print(f"\n{timestamp} => KeyboardInterrupt (Ctrl-C) detected.")
        print(f"{timestamp} => GPU availability test exited gracefully.")
        sys.exit(0)
