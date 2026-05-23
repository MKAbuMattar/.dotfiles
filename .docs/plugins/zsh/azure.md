# azure-plugin

## NAME

**azure-plugin** — Azure CLI completion, subscription helpers, and prompt
segment.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "azure" ...)
```

## DESCRIPTION

Wires up zsh-side conveniences for the Azure CLI (`az`). It defines small
helpers to inspect/select the current Azure subscription, attaches `compctl`
completion to the `azss` command (subscription switcher, expected to be
provided elsewhere), exposes an `azure_prompt_info` segment showing the
default subscription, and finally sources the Azure CLI's bash completion via
`bashcompinit` from one of several common locations.

## EFFECTS

- Returns immediately if `az` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Defines `azgs`, `az_subscriptions`, `_az_subscriptions`, and
  `azure_prompt_info`.
- Registers `compctl -K _az_subscriptions azss`.
- Loads `bashcompinit` and sources the discovered Azure CLI completion script
  (`az_zsh_completer.sh` from `$PATH`, Homebrew prefix `etc/bash_completion.d/az`,
  or Linux `/etc/bash_completion.d/azure-cli`).

## FUNCTIONS

| Function                 | Purpose                                                                                                                                                                                             |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `azgs`                   | "Azure get subscription" — prints the active subscription name via `az account show --query 'name'`.                                                                                                |
| `az_subscriptions`       | List all available subscriptions via `az account list --all --query '[*].name'`.                                                                                                                    |
| `_az_subscriptions`      | `compctl` callback that fills completions for `azss`.                                                                                                                                               |
| `azure_prompt_info`      | Reads `${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json` with `jq` to extract the default subscription and prints `<az:NAME>`. No-op if `azureProfile.json` is missing or `jq` is not installed. |
| `_az-homebrew-installed` | Internal helper used to resolve the Homebrew prefix.                                                                                                                                                |

## ENVIRONMENT

| Variable                             | Read/Set         | Default            | Purpose                                                  |
| ------------------------------------ | ---------------- | ------------------ | -------------------------------------------------------- |
| `ZSH_CACHE_DIR`                      | Read (defaulted) | `$HOME/.cache/zsh` | Completion cache directory.                              |
| `AZURE_CONFIG_DIR`                   | Read             | `$HOME/.azure`     | Where `azure_prompt_info` looks for `azureProfile.json`. |
| `ZSH_THEME_AZURE_PREFIX` / `_SUFFIX` | Read             | `<az:` / `>`       | Decoration for the prompt segment.                       |

## FILES

| Path                                                        | Role                           |
| ----------------------------------------------------------- | ------------------------------ |
| `${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json`       | Read by `azure_prompt_info`.   |
| `aws_zsh_completer.sh` / `az_zsh_completer.sh` (on `$PATH`) | Preferred Azure CLI completer. |
| `<brew-prefix>/etc/bash_completion.d/az`                    | Homebrew fallback.             |
| `/etc/bash_completion.d/azure-cli`                          | Linux fallback.                |

## REQUIREMENTS

- `az` CLI on `$PATH`. The plugin no-ops otherwise.
- `jq` for `azure_prompt_info` to produce output.
- An installed Azure CLI completion script at one of the expected paths.

## SEE ALSO

- [.docs/aliases/azure.md](../../aliases/azure.md)
- [.docs/README.md](../../README.md)
