# protonmail-bridge

[![Build Status](https://drone.theautomation.nl/api/badges/theautomation/protonmail-bridge/status.svg)](https://drone.theautomation.nl/theautomation/protonmail-bridge)
![GitHub repo size](https://img.shields.io/github/repo-size/theautomation/protonmail-bridge?logo=Github)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/theautomation/protonmail-bridge?logo=github)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/theautomation/protonmail-bridge/main?logo=github)

<img src="https://github.com/theautomation/kubernetes-gitops/blob/main/assets/img/k8s.png?raw=true" alt="K8s" style="height: 30px; width:30px;"/>
Application running in Kubernetes

## Init

Start a pod with the following command

```yaml
command: ["/bin/sh"]
args: ["-c", "while true; do sleep 3600; done"]
```

Get inside the container and run the following command for initialization

```bash
bash ./protonmail/entrypoint.sh init
```

Run `login` and enter the credentials

After sync run `info` to display configuration for IMAP or SMTP

Now change the deployment yaml to the following:

```yaml
command: ["/bin/bash", "/protonmail/entrypoint.sh"]
```
