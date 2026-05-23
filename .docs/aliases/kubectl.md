# kubectl-aliases

## NAME

**kubectl-aliases** — comprehensive short aliases for the Kubernetes `kubectl` command-line client.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "kubectl" ...)
```

## DESCRIPTION

A large catalog of short prefixed aliases (`k*`) covering most everyday `kubectl` operations: get/describe/edit/delete across all the core resource kinds, contexts and namespaces, rollouts, scaling, port-forwarding, logs, copy, and an `--all-namespaces` wrapper. The module is gated by `(( ! $+commands[kubectl] )) && return`, so it loads only when `kubectl` is on `$PATH`.

The module also defines helper functions: `_kca` (lambda used by the `kca` alias to inject `--all-namespaces`), `kres` (sets a `REFRESHED_AT` env var on a resource to force pod rollout), and a private `_build_kubectl_out_alias` factory that generates the `kj` / `kjx` / `ky` JSON/YAML pipes together with their `compdef` completion shims.

## ALIASES

### Core

| Alias   | Expansion                                            | Description                                      |
| ------- | ---------------------------------------------------- | ------------------------------------------------ |
| `k`     | `kubectl`                                            | Run kubectl                                      |
| `kca`   | `_kca(){ kubectl "$@" --all-namespaces; ... }; _kca` | Run a kubectl subcommand with `--all-namespaces` |
| `kaf`   | `kubectl apply -f`                                   | Apply a YAML file                                |
| `kapk`  | `kubectl apply -k`                                   | Apply a kustomization directory                  |
| `keti`  | `kubectl exec -t -i`                                 | Drop into an interactive container shell         |
| `kcp`   | `kubectl cp`                                         | Copy files to/from a pod                         |
| `kpf`   | `kubectl port-forward`                               | Forward a local port to a pod/service            |
| `kga`   | `kubectl get all`                                    | Get all resources in current namespace           |
| `kgaa`  | `kubectl get all --all-namespaces`                   | Get all resources cluster-wide                   |
| `kdel`  | `kubectl delete`                                     | Generic delete                                   |
| `kdelf` | `kubectl delete -f`                                  | Delete from manifest                             |
| `kdelk` | `kubectl delete -k`                                  | Delete a kustomization                           |
| `kge`   | `kubectl get events --sort-by=".lastTimestamp"`      | List events newest-first                         |
| `kgew`  | `kubectl get events ... --watch`                     | Watch events                                     |

### Contexts and Config

| Alias  | Expansion                                          | Description              |
| ------ | -------------------------------------------------- | ------------------------ |
| `kcuc` | `kubectl config use-context`                       | Switch context           |
| `kcsc` | `kubectl config set-context`                       | Set context              |
| `kcdc` | `kubectl config delete-context`                    | Delete context           |
| `kccc` | `kubectl config current-context`                   | Show current context     |
| `kcgc` | `kubectl config get-contexts`                      | List contexts            |
| `kcn`  | `kubectl config set-context --current --namespace` | Switch default namespace |

### Pods

| Alias     | Expansion                                   | Description                             |
| --------- | ------------------------------------------- | --------------------------------------- |
| `kgp`     | `kubectl get pods`                          | List pods                               |
| `kgpl`    | `kgp -l`                                    | List pods by label selector             |
| `kgpn`    | `kgp -n`                                    | List pods in namespace                  |
| `kgpsl`   | `kubectl get pods --show-labels`            | List pods with labels                   |
| `kgpa`    | `kubectl get pods --all-namespaces`         | List pods cluster-wide                  |
| `kgpw`    | `kgp --watch`                               | Watch pods                              |
| `kgpwide` | `kgp -o wide`                               | List pods with wide output              |
| `kgpall`  | `kubectl get pods --all-namespaces -o wide` | List all pods cluster-wide, wide output |
| `kep`     | `kubectl edit pods`                         | Edit a pod                              |
| `kdp`     | `kubectl describe pods`                     | Describe a pod                          |
| `kdelp`   | `kubectl delete pods`                       | Delete a pod                            |

### Services

| Alias     | Expansion                          | Description                |
| --------- | ---------------------------------- | -------------------------- |
| `kgs`     | `kubectl get svc`                  | List services              |
| `kgsa`    | `kubectl get svc --all-namespaces` | List services cluster-wide |
| `kgsw`    | `kgs --watch`                      | Watch services             |
| `kgswide` | `kgs -o wide`                      | Services with wide output  |
| `kes`     | `kubectl edit svc`                 | Edit a service             |
| `kds`     | `kubectl describe svc`             | Describe a service         |
| `kdels`   | `kubectl delete svc`               | Delete a service           |

### Ingress

| Alias   | Expansion                              | Description                 |
| ------- | -------------------------------------- | --------------------------- |
| `kgi`   | `kubectl get ingress`                  | List ingresses              |
| `kgia`  | `kubectl get ingress --all-namespaces` | List ingresses cluster-wide |
| `kei`   | `kubectl edit ingress`                 | Edit an ingress             |
| `kdi`   | `kubectl describe ingress`             | Describe an ingress         |
| `kdeli` | `kubectl delete ingress`               | Delete an ingress           |

### Namespaces

| Alias    | Expansion                    | Description          |
| -------- | ---------------------------- | -------------------- |
| `kgns`   | `kubectl get namespaces`     | List namespaces      |
| `kens`   | `kubectl edit namespace`     | Edit a namespace     |
| `kdns`   | `kubectl describe namespace` | Describe a namespace |
| `kdelns` | `kubectl delete namespace`   | Delete a namespace   |

### ConfigMaps & Secrets

| Alias     | Expansion                                 | Description                  |
| --------- | ----------------------------------------- | ---------------------------- |
| `kgcm`    | `kubectl get configmaps`                  | List configmaps              |
| `kgcma`   | `kubectl get configmaps --all-namespaces` | List configmaps cluster-wide |
| `kecm`    | `kubectl edit configmap`                  | Edit a configmap             |
| `kdcm`    | `kubectl describe configmap`              | Describe a configmap         |
| `kdelcm`  | `kubectl delete configmap`                | Delete a configmap           |
| `kgsec`   | `kubectl get secret`                      | List secrets                 |
| `kgseca`  | `kubectl get secret --all-namespaces`     | List secrets cluster-wide    |
| `kdsec`   | `kubectl describe secret`                 | Describe a secret            |
| `kdelsec` | `kubectl delete secret`                   | Delete a secret              |

### Deployments

| Alias     | Expansion                                 | Description                    |
| --------- | ----------------------------------------- | ------------------------------ |
| `kgd`     | `kubectl get deployment`                  | List deployments               |
| `kgda`    | `kubectl get deployment --all-namespaces` | Deployments cluster-wide       |
| `kgdw`    | `kgd --watch`                             | Watch deployments              |
| `kgdwide` | `kgd -o wide`                             | Deployments with wide output   |
| `ked`     | `kubectl edit deployment`                 | Edit a deployment              |
| `kdd`     | `kubectl describe deployment`             | Describe a deployment          |
| `kdeld`   | `kubectl delete deployment`               | Delete a deployment            |
| `ksd`     | `kubectl scale deployment`                | Scale a deployment             |
| `krsd`    | `kubectl rollout status deployment`       | Rollout status of a deployment |
| `krrd`    | `kubectl rollout restart deployment`      | Restart a deployment           |

### ReplicaSets & Rollouts

| Alias  | Expansion                     | Description           |
| ------ | ----------------------------- | --------------------- |
| `kgrs` | `kubectl get replicaset`      | List replicasets      |
| `kdrs` | `kubectl describe replicaset` | Describe a replicaset |
| `kers` | `kubectl edit replicaset`     | Edit a replicaset     |
| `krh`  | `kubectl rollout history`     | Show rollout history  |
| `kru`  | `kubectl rollout undo`        | Undo a rollout        |

### StatefulSets

| Alias      | Expansion                                  | Description                     |
| ---------- | ------------------------------------------ | ------------------------------- |
| `kgss`     | `kubectl get statefulset`                  | List statefulsets               |
| `kgssa`    | `kubectl get statefulset --all-namespaces` | StatefulSets cluster-wide       |
| `kgssw`    | `kgss --watch`                             | Watch statefulsets              |
| `kgsswide` | `kgss -o wide`                             | StatefulSets with wide output   |
| `kess`     | `kubectl edit statefulset`                 | Edit a statefulset              |
| `kdss`     | `kubectl describe statefulset`             | Describe a statefulset          |
| `kdelss`   | `kubectl delete statefulset`               | Delete a statefulset            |
| `ksss`     | `kubectl scale statefulset`                | Scale a statefulset             |
| `krsss`    | `kubectl rollout status statefulset`       | Rollout status of a statefulset |
| `krrss`    | `kubectl rollout restart statefulset`      | Restart a statefulset           |

### Logs

| Alias   | Expansion                    | Description                      |
| ------- | ---------------------------- | -------------------------------- |
| `kl`    | `kubectl logs`               | Show logs                        |
| `kl1h`  | `kubectl logs --since 1h`    | Logs from the last hour          |
| `kl1m`  | `kubectl logs --since 1m`    | Logs from the last minute        |
| `kl1s`  | `kubectl logs --since 1s`    | Logs from the last second        |
| `klf`   | `kubectl logs -f`            | Follow logs                      |
| `klf1h` | `kubectl logs --since 1h -f` | Follow logs from the last hour   |
| `klf1m` | `kubectl logs --since 1m -f` | Follow logs from the last minute |
| `klf1s` | `kubectl logs --since 1s -f` | Follow logs from the last second |

### Nodes

| Alias    | Expansion                         | Description            |
| -------- | --------------------------------- | ---------------------- |
| `kgno`   | `kubectl get nodes`               | List nodes             |
| `kgnosl` | `kubectl get nodes --show-labels` | List nodes with labels |
| `keno`   | `kubectl edit node`               | Edit a node            |
| `kdno`   | `kubectl describe node`           | Describe a node        |
| `kdelno` | `kubectl delete node`             | Delete a node          |

### PVCs

| Alias     | Expansion                          | Description       |
| --------- | ---------------------------------- | ----------------- |
| `kgpvc`   | `kubectl get pvc`                  | List PVCs         |
| `kgpvca`  | `kubectl get pvc --all-namespaces` | PVCs cluster-wide |
| `kgpvcw`  | `kgpvc --watch`                    | Watch PVCs        |
| `kepvc`   | `kubectl edit pvc`                 | Edit a PVC        |
| `kdpvc`   | `kubectl describe pvc`             | Describe a PVC    |
| `kdelpvc` | `kubectl delete pvc`               | Delete a PVC      |

### Service Accounts

| Alias    | Expansion             | Description                |
| -------- | --------------------- | -------------------------- |
| `kdsa`   | `kubectl describe sa` | Describe a service account |
| `kdelsa` | `kubectl delete sa`   | Delete a service account   |

### DaemonSets

| Alias    | Expansion                                | Description             |
| -------- | ---------------------------------------- | ----------------------- |
| `kgds`   | `kubectl get daemonset`                  | List daemonsets         |
| `kgdsa`  | `kubectl get daemonset --all-namespaces` | DaemonSets cluster-wide |
| `kgdsw`  | `kgds --watch`                           | Watch daemonsets        |
| `keds`   | `kubectl edit daemonset`                 | Edit a daemonset        |
| `kdds`   | `kubectl describe daemonset`             | Describe a daemonset    |
| `kdelds` | `kubectl delete daemonset`               | Delete a daemonset      |

### Jobs & CronJobs

| Alias    | Expansion                  | Description        |
| -------- | -------------------------- | ------------------ |
| `kgj`    | `kubectl get job`          | List jobs          |
| `kej`    | `kubectl edit job`         | Edit a job         |
| `kdj`    | `kubectl describe job`     | Describe a job     |
| `kdelj`  | `kubectl delete job`       | Delete a job       |
| `kgcj`   | `kubectl get cronjob`      | List cronjobs      |
| `kecj`   | `kubectl edit cronjob`     | Edit a cronjob     |
| `kdcj`   | `kubectl describe cronjob` | Describe a cronjob |
| `kdelcj` | `kubectl delete cronjob`   | Delete a cronjob   |

### Output Pipes (built dynamically)

| Alias | Expansion                    | Description                                         |
| ----- | ---------------------------- | --------------------------------------------------- |
| `kj`  | `kubectl "$@" -o json \| jq` | Pipe kubectl JSON output through `jq`               |
| `kjx` | `kubectl "$@" -o json \| fx` | Pipe kubectl JSON output through `fx`               |
| `ky`  | `kubectl "$@" -o yaml \| yh` | Pipe kubectl YAML output through `yh` (highlighter) |

Each of these is generated by `_build_kubectl_out_alias`, which also registers `compdef _<name> <name>` so kubectl completions continue to work.

## FUNCTIONS

- **`kres <resource> <name>`** — sets `REFRESHED_AT=YYYYMMDDHHMMSS` on the targeted resource via `kubectl set env`, which forces controllers to roll the pods.
- **`_build_kubectl_out_alias <name> <body>`** — internal factory used to define `kj`, `kjx`, `ky` together with their completion shims; unfunctioned after use.

## REQUIREMENTS

- `kubectl` installed and on `$PATH`.
- For `kj` / `kjx` / `ky`: the matching helpers (`jq`, `fx`, `yh`) must be installed to actually pipe output.
- A working kubeconfig.

## EXAMPLES

```bash
# Watch all pods cluster-wide
kca get pods --watch

# Tail the last minute of logs for a pod
klf1m my-pod

# Force a deployment to roll its pods via a timestamp env var
kres deployment/my-app

# Inspect a service as parsed JSON
kj get svc my-svc

# Switch the current namespace
kcn my-namespace
```

## SEE ALSO

- [.docs/aliases/k9s](k9s.md)
- [.docs/aliases/helm](helm.md)
- [.docs/README.md](../README.md)
