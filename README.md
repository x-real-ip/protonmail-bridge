# protonmail-bridge

![GitHub repo size](https://img.shields.io/github/repo-size/theautomation/protonmail-bridge?logo=Github)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/theautomation/protonmail-bridge?logo=github)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/theautomation/protonmail-bridge/main?logo=github)

Application running in Kubernetes <img src="https://github.com/theautomation/kubernetes-gitops/blob/main/assets/img/k8s.png?raw=true" alt="K8s" style="height: 30px; width:30px;"/>

## Steps for new instance

1. kubectl apply -f manifest.yaml
2. get into the container.
   ```console
   kubectl exec -it <POD> -- /bin/bash
   ```
3. Find PID for `the protonmail-bridge --cli` proces with `TOP`
4. Kill `protonmail-bridge --cli` proces
   ```console
   kill <PID>
   ```
5. start `protonmail-bridge --cli` from the console
6. login
7. show information with `info` command in the consol