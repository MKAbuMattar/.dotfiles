# helm-aliases

## NAME

**helm-aliases** — short prefixes for the Helm v3 CLI (Kubernetes package manager).

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "helm" ...)
```

## DESCRIPTION

The module exits early via `(( ! $+commands[helm] )) && return` when
`helm` is not on `$PATH`, so the aliases never pollute shells on machines
without Helm. When loaded, it covers repository management, chart
authoring, release lifecycle, dependency management, plugin management,
and a few common workflow combos (atomic install/upgrade, watch).

## ALIASES

### General

| Alias  | Expansion      | Description          |
| ------ | -------------- | -------------------- |
| `h`    | `helm`         | Bare CLI.            |
| `hv`   | `helm version` | Version.             |
| `hh`   | `helm help`    | Help.                |
| `henv` | `helm env`     | Print Helm env vars. |

### Repository management

| Alias | Expansion          | Description                 |
| ----- | ------------------ | --------------------------- |
| `hr`  | `helm repo`        | Repo subcommand entrypoint. |
| `hra` | `helm repo add`    | Add a repo.                 |
| `hrr` | `helm repo remove` | Remove a repo.              |
| `hrl` | `helm repo list`   | List repos.                 |
| `hru` | `helm repo update` | Refresh indexes.            |
| `hri` | `helm repo index`  | Build a local repo index.   |

### Chart authoring

| Alias      | Expansion          | Description                 |
| ---------- | ------------------ | --------------------------- |
| `hc`       | `helm create`      | Scaffold a new chart.       |
| `hpkg`     | `helm package`     | Package a chart.            |
| `hlint`    | `helm lint`        | Lint chart.                 |
| `hshow`    | `helm show`        | Show metadata (entrypoint). |
| `hshowa`   | `helm show all`    | Show everything.            |
| `hshowc`   | `helm show chart`  | Show Chart.yaml.            |
| `hshowv`   | `helm show values` | Show default values.        |
| `hshowcrd` | `helm show crds`   | Show CRDs from chart.       |

### Release lifecycle

| Alias   | Expansion                               | Description                      |
| ------- | --------------------------------------- | -------------------------------- |
| `hi`    | `helm install`                          | Install a release.               |
| `hup`   | `helm upgrade`                          | Upgrade a release.               |
| `hui`   | `helm upgrade --install`                | Upgrade or install if missing.   |
| `huir`  | `helm upgrade --install --reuse-values` | Upgrade reusing previous values. |
| `hun`   | `helm uninstall`                        | Uninstall a release.             |
| `hdel`  | `helm uninstall`                        | Synonym for `hun`.               |
| `hls`   | `helm list`                             | List releases in cur ns.         |
| `hlsa`  | `helm list --all`                       | Include uninstalled.             |
| `hlsan` | `helm list --all-namespaces`            | All namespaces.                  |

### Inspection

| Alias   | Expansion           | Description                         |
| ------- | ------------------- | ----------------------------------- |
| `hget`  | `helm get`          | Get release artefacts (entrypoint). |
| `hgeta` | `helm get all`      | All artefacts.                      |
| `hgetv` | `helm get values`   | User-supplied values.               |
| `hgetm` | `helm get manifest` | Rendered manifest.                  |
| `hgeth` | `helm get hooks`    | Lifecycle hooks.                    |
| `hgetn` | `helm get notes`    | Post-install notes.                 |
| `hst`   | `helm status`       | Release status.                     |
| `hhist` | `helm history`      | Revision history.                   |
| `hroll` | `helm rollback`     | Roll back to a previous revision.   |

### Testing and rendering

| Alias        | Expansion                        | Description               |
| ------------ | -------------------------------- | ------------------------- |
| `htest`      | `helm test`                      | Run chart tests.          |
| `hdry`       | `helm install --dry-run --debug` | Render without applying.  |
| `htemp`      | `helm template`                  | Render templates locally. |
| `htempdebug` | `helm template --debug`          | Render with debug.        |

### Dependencies

| Alias   | Expansion                | Description              |
| ------- | ------------------------ | ------------------------ |
| `hdep`  | `helm dependency`        | Dependency subcommand.   |
| `hdepu` | `helm dependency update` | Update `Chart.lock`.     |
| `hdepb` | `helm dependency build`  | Build charts/ from lock. |
| `hdepl` | `helm dependency list`   | List declared deps.      |

### Search

| Alias      | Expansion          | Description          |
| ---------- | ------------------ | -------------------- |
| `hsearch`  | `helm search`      | Search subcommand.   |
| `hsearchr` | `helm search repo` | Search repos.        |
| `hsearchh` | `helm search hub`  | Search Artifact Hub. |

### Plugins

| Alias   | Expansion               | Description        |
| ------- | ----------------------- | ------------------ |
| `hpl`   | `helm plugin`           | Plugin subcommand. |
| `hpli`  | `helm plugin install`   | Install plugin.    |
| `hpll`  | `helm plugin list`      | List plugins.      |
| `hplu`  | `helm plugin update`    | Update plugins.    |
| `hplun` | `helm plugin uninstall` | Uninstall plugin.  |

### Download / verify

| Alias     | Expansion     | Description                 |
| --------- | ------------- | --------------------------- |
| `hpull`   | `helm pull`   | Pull a chart locally.       |
| `hfetch`  | `helm pull`   | Legacy name.                |
| `hverify` | `helm verify` | Verify a chart's signature. |

### Common workflows

| Alias    | Expansion                                 | Description                |
| -------- | ----------------------------------------- | -------------------------- |
| `hia`    | `helm install --atomic`                   | Roll back on failure.      |
| `huia`   | `helm upgrade --install --atomic`         | Atomic upgrade-or-install. |
| `huiaf`  | `helm upgrade --install --atomic --force` | Force atomic.              |
| `hwatch` | `watch helm list`                         | Live release list.         |

## REQUIREMENTS

- `helm` v3+ on `$PATH` at shell-startup (probed with
  `(( ! $+commands[helm] )) && return`).
- A reachable Kubernetes cluster (`KUBECONFIG`) for any release
  operations.
- `watch(1)` for `hwatch`.

## EXAMPLES

```bash
hra bitnami https://charts.bitnami.com/bitnami
hru
hsearchr nginx
huia my-app bitnami/nginx -n web --create-namespace
hhist my-app
hroll my-app 2
hdry my-app ./chart -f values.yaml
```

## SEE ALSO

- [.docs/README.md](../README.md)
