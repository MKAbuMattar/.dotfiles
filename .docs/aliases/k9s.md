# k9s-aliases

## NAME

**k9s-aliases** — short aliases for launching the `k9s` Kubernetes TUI with common views, contexts, and modes.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "k9s" ...)
```

## DESCRIPTION

Provides shortcuts for invoking `k9s` with specific namespaces, contexts, resource views (`-c <kind>`), readonly/write/headless modes, and log levels. The module is gated by `(( ! $+commands[k9s] )) && return`, so it only loads when `k9s` is on `$PATH`.

## ALIASES

### General

| Alias         | Expansion     | Description                   |
| ------------- | ------------- | ----------------------------- |
| `k9`          | `k9s`         | Launch k9s                    |
| `k9s-info`    | `k9s info`    | Print k9s configuration paths |
| `k9s-version` | `k9s version` | Show k9s version              |
| `k9s-help`    | `k9s help`    | Show k9s help                 |

### Namespace / Context

| Alias  | Expansion              | Description                        |
| ------ | ---------------------- | ---------------------------------- |
| `k9n`  | `k9s -n`               | Start in a specific namespace      |
| `k9sa` | `k9s --all-namespaces` | Start across all namespaces        |
| `k9c`  | `k9s --context`        | Start with a specific kube context |

### Modes

| Alias    | Expansion           | Description                                 |
| -------- | ------------------- | ------------------------------------------- |
| `k9ro`   | `k9s --readonly`    | Start in read-only mode                     |
| `k9rw`   | `k9s --write`       | Start in write mode (default)               |
| `k9head` | `k9s --headless`    | Headless mode (useful for screen recording) |
| `k9dump` | `k9s --screen-dump` | Dump screen contents                        |

### Resource Views (`-c <kind>`)

| Alias   | Expansion            | Description                        |
| ------- | -------------------- | ---------------------------------- |
| `k9p`   | `k9s -c pod`         | Open pods view                     |
| `k9d`   | `k9s -c deploy`      | Open deployments view              |
| `k9svc` | `k9s -c svc`         | Open services view                 |
| `k9ing` | `k9s -c ingress`     | Open ingresses view                |
| `k9cm`  | `k9s -c configmap`   | Open configmaps view               |
| `k9sec` | `k9s -c secret`      | Open secrets view                  |
| `k9ns`  | `k9s -c namespace`   | Open namespaces view               |
| `k9no`  | `k9s -c node`        | Open nodes view                    |
| `k9pv`  | `k9s -c pv`          | Open persistent volumes view       |
| `k9pvc` | `k9s -c pvc`         | Open persistent volume claims view |
| `k9sts` | `k9s -c statefulset` | Open statefulsets view             |
| `k9ds`  | `k9s -c daemonset`   | Open daemonsets view               |
| `k9job` | `k9s -c job`         | Open jobs view                     |
| `k9cj`  | `k9s -c cronjob`     | Open cronjobs view                 |

### Logging

| Alias      | Expansion              | Description                  |
| ---------- | ---------------------- | ---------------------------- |
| `k9sl`     | `k9s --logLevel`       | Set log level (pass a value) |
| `k9sdebug` | `k9s --logLevel debug` | Start with debug logging     |

## REQUIREMENTS

- `k9s` installed and on `$PATH`.
- A working kubeconfig (`~/.kube/config` or `$KUBECONFIG`) pointing at one or more clusters.

## EXAMPLES

```bash
# Open k9s in the kube-system namespace
k9n kube-system

# Browse pods across all namespaces
k9sa

# Launch the deployments view in read-only mode
k9ro -c deploy

# Switch contexts on launch
k9c prod-cluster
```

## SEE ALSO

- [.docs/aliases/kubectl](kubectl.md)
- [.docs/README.md](../README.md)
