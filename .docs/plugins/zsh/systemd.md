# systemd-plugin

## NAME

**systemd-plugin** — completion wiring for `systemctl` and `journalctl`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "systemd" ...)
```

## DESCRIPTION

Loads zsh completions for the systemd CLI family. The plugin no-ops if `systemctl` is not on `$PATH`. Otherwise it ensures `$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, then symlinks the system-provided completion scripts for `systemctl` and `journalctl` into the cache so they are managed alongside the other framework completions. The completions themselves ship with systemd in `/usr/share/zsh/site-functions/` and would normally be picked up automatically — the symlink dance just keeps the user cache as the single source of truth. Completion is then reloaded via `compinit`.

## EFFECTS

- Returns immediately when `systemctl` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath` (if not already present).
- Symlinks `/usr/share/zsh/site-functions/_systemctl` into the cache if the source exists and the target does not.
- Symlinks `/usr/share/zsh/site-functions/_journalctl` into the cache under the same conditions.
- Runs `autoload -Uz compinit; compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                          |
| --------------- | ------------------------- | ------------------ | ------------------------------------------------ |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where completion symlinks and the compdump live. |

## FILES

| Path                                              | Role                                                |
| ------------------------------------------------- | --------------------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_systemctl`           | Symlink to the system `_systemctl` completion.      |
| `$ZSH_CACHE_DIR/completions/_journalctl`          | Symlink to the system `_journalctl` completion.     |
| `$ZSH_CACHE_DIR/.zcompdump`                       | Compinit dump file.                                 |
| `/usr/share/zsh/site-functions/_systemctl`        | Source completion (systemd package).                |
| `/usr/share/zsh/site-functions/_journalctl`       | Source completion (systemd package).                |

## REQUIREMENTS

- `systemctl` on `$PATH`. The plugin no-ops otherwise.
- At least one of the system completion files must exist for the corresponding symlink to be created. On distros that omit them (rare) the plugin silently does nothing — completion still works through the default systemd-bash completion if available, but zsh-native completion will be unavailable.

## SEE ALSO

- [.docs/aliases/systemd](../../aliases/systemd.md)
- [.docs/utils/systemd](../../utils/systemd.md)
- [.docs/README.md](../../README.md)
