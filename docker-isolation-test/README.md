# Installation Instructions

## Zarf Packages

Once all tools are installed and in-place, run the following command:

```bash
zarf package deploy --confirm
```

Use the `TAB` button to scroll through the packages, installing them in the following order:

1. k3d-local
2. dubbd-k3d
3. leapfrogai-api
4. ctransformers
5. whidper
6. doug-translate

For more detailed instructions on how these packages were created, and how to install a Transcription and Summarization stack using LeapforgAI and Zarf, see the context located in [INSTALL.md](./INSTALL.md)

## Load Balancer Exposing

The command to expose docker is: `k3d cluster edit dubbd --port-add "8083:30535@loadbalancer"`` or whatever port you want to use instead of 8083 all the connections are https so if you try to reach doug-translate from your browser you'll need to hit https://localhost:8083
