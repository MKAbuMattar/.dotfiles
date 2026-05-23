# systemd-aliases

## NAME

**systemd-aliases** — short forms for `systemctl` and `journalctl` on systemd-based hosts.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "systemd" ...)
```

## DESCRIPTION

Provides terse aliases over `systemctl` and `journalctl`. The module is split into two groups: a read-only set that works for any user, and a privileged set that wraps mutating `systemctl` verbs with `sudo`. The whole file no-ops if `systemctl` is not on `$PATH`, so it is safe to load on macOS or in containers. The privileged half also no-ops if `sudo` is not available, keeping the read-only half usable inside locked-down environments.

Pair with [.docs/utils/systemd](../utils/systemd.md) for fzf-driven service pickers, journal tailing, and reboot-needed checks.

## ALIASES

### Read-only (no sudo)

| Alias  | Expansion                                  | Description                                  |
| ------ | ------------------------------------------ | -------------------------------------------- |
| `sc`   | `systemctl`                                | Bare `systemctl`.                            |
| `scs`  | `systemctl status`                         | Show unit status.                            |
| `scq`  | `systemctl is-active`                      | Quick is-active probe (exit code).           |
| `sce`  | `systemctl is-enabled`                     | Is-enabled probe.                            |
| `scl`  | `systemctl list-units --type=service`      | List service units currently loaded.         |
| `scll` | `systemctl list-unit-files --type=service` | List service unit files installed on disk.   |
| `scf`  | `systemctl list-units --state=failed`      | Show only failed units.                      |
| `sct`  | `systemctl list-timers --all`              | Show all timers plus next firing time.       |
| `scsk` | `systemctl list-sockets`                   | List socket units.                           |

### Journal

| Alias     | Expansion              | Description                              |
| --------- | ---------------------- | ---------------------------------------- |
| `jctl`    | `journalctl`           | Plain journalctl.                        |
| `jctlu`   | `journalctl -u`        | Logs for a specific unit (`jctlu nginx`).|
| `jctlf`   | `journalctl -f`        | Follow the whole journal.                |
| `jctluf`  | `journalctl -fu`       | Follow a specific unit.                  |
| `jctlb`   | `journalctl -b`        | Current boot only.                       |
| `jctle`   | `journalctl -p err`    | Errors only (priority err).              |
| `jctlw`   | `journalctl -p warning`| Warnings + errors.                       |

### Privileged (sudo, only if `sudo` is on PATH)

| Alias     | Expansion                          | Description                                    |
| --------- | ---------------------------------- | ---------------------------------------------- |
| `scr`     | `sudo systemctl restart`           | Restart a unit.                                |
| `scst`    | `sudo systemctl start`             | Start a unit.                                  |
| `scsp`    | `sudo systemctl stop`              | Stop a unit.                                   |
| `scrl`    | `sudo systemctl reload`            | Reload a unit's configuration.                 |
| `scen`    | `sudo systemctl enable`            | Enable at boot.                                |
| `scens`   | `sudo systemctl enable --now`      | Enable and start immediately.                  |
| `scdis`   | `sudo systemctl disable`           | Disable from boot.                             |
| `scdiss`  | `sudo systemctl disable --now`     | Disable and stop immediately.                  |
| `scmsk`   | `sudo systemctl mask`              | Mask a unit (prevent any activation).          |
| `scumsk`  | `sudo systemctl unmask`            | Unmask a unit.                                 |
| `scdr`    | `sudo systemctl daemon-reload`     | Reload unit files after edits.                 |

## REQUIREMENTS

- `systemctl` on `$PATH` (the whole module no-ops otherwise).
- `sudo` on `$PATH` is needed for the privileged group; the read-only and journal groups work without it.
- `journalctl` (ships with systemd) for the `jctl*` aliases.

## EXAMPLES

```bash
scs sshd                 # status of the sshd unit
scens nginx              # enable + start nginx in one shot
jctluf nginx             # tail nginx logs
scf                      # any failed units?
sct                      # next time each timer fires
scdr                     # after editing /etc/systemd/system/foo.service
```

## SEE ALSO

- [.docs/utils/systemd](../utils/systemd.md)
- [.docs/plugins/zsh/systemd](../plugins/zsh/systemd.md)
- [.docs/README.md](../README.md)
