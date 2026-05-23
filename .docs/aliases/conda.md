# conda-aliases

## NAME

**conda-aliases** — short prefixes for the `conda` package and environment manager.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "conda" ...)
```

## DESCRIPTION

Two- to five-character shortcuts that cover the day-to-day Conda workflow:
activating environments, listing, installing, updating, removing, and
exporting environment specs. All aliases load unconditionally — there is no
runtime probe for the `conda` binary, so `conda` must already be on
`$PATH` (typically by sourcing `conda.sh` or running `conda init zsh`).

## ALIASES

### Environment activation

| Alias  | Expansion             | Description                     |
| ------ | --------------------- | ------------------------------- |
| `cna`  | `conda activate`      | Activate the named environment. |
| `cnab` | `conda activate base` | Jump back to the `base` env.    |
| `cnde` | `conda deactivate`    | Deactivate the current env.     |
| `cnel` | `conda env list`      | List all environments.          |

### Environment creation

| Alias  | Expansion             | Description                      |
| ------ | --------------------- | -------------------------------- |
| `cncf` | `conda env create -f` | Create env from a YAML file.     |
| `cncn` | `conda create -y -n`  | Create named env (auto-yes).     |
| `cncp` | `conda create -y -p`  | Create env at a path (auto-yes). |
| `cncr` | `conda create -n`     | Create named env (interactive).  |

### Configuration

| Alias    | Expansion                    | Description          |
| -------- | ---------------------------- | -------------------- |
| `cnconf` | `conda config`               | Manage config.       |
| `cncss`  | `conda config --show-source` | Show config sources. |

### Packages

| Alias   | Expansion                               | Description                  |
| ------- | --------------------------------------- | ---------------------------- |
| `cni`   | `conda install`                         | Install package(s).          |
| `cniy`  | `conda install -y`                      | Install with auto-yes.       |
| `cnl`   | `conda list`                            | List installed packages.     |
| `cnle`  | `conda list --export`                   | Export to requirements form. |
| `cnles` | `conda list --explicit > spec-file.txt` | Write an explicit lock file. |
| `cnsr`  | `conda search`                          | Search for packages.         |

### Updating

| Alias  | Expansion            | Description                   |
| ------ | -------------------- | ----------------------------- |
| `cnu`  | `conda update`       | Update package(s).            |
| `cnua` | `conda update --all` | Update everything in the env. |
| `cnuc` | `conda update conda` | Update conda itself.          |

### Removal

| Alias  | Expansion                  | Description           |
| ------ | -------------------------- | --------------------- |
| `cnr`  | `conda remove`             | Remove package(s).    |
| `cnry` | `conda remove -y`          | Remove with auto-yes. |
| `cnrn` | `conda remove -y --all -n` | Delete a named env.   |
| `cnrp` | `conda remove -y --all -p` | Delete env at a path. |

## REQUIREMENTS

- `conda` — Miniconda / Anaconda / Mambaforge, initialised for zsh.

## EXAMPLES

```bash
cncn dev python=3.12
cna dev
cni numpy pandas
cnles                  # write spec-file.txt
cnrn dev               # tear it down
```

## SEE ALSO

- [.docs/README.md](../README.md)
