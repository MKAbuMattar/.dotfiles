# systemd-utils

## NAME

**systemd-utils** — interactive helpers around `systemctl`, `journalctl`, and `systemd-analyze`.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "systemd" ...)
```

## DESCRIPTION

Five shell functions that complement the bare-bones aliases in [.docs/aliases/systemd](../aliases/systemd.md). The file no-ops if `systemctl` is not on `$PATH`, so it is safe to load anywhere. `sc-pick` requires `fzf`; `sc-reboot-needed` adapts itself to `dnf`/`rpm` on Fedora-family systems and falls back to `dpkg` on Debian-family systems.

## FUNCTIONS

### `sc-pick`

Interactive picker that lists every `.service` unit and shows the chosen one's status.

**Arguments:** none.

**Behavior:**

Runs `systemctl list-units --type=service --all --no-legend`, pipes unit names through `fzf` with a `systemctl status` preview, and on selection prints the picked unit's full status with `--no-pager -l`. Errors out with a message if `fzf` is not installed.

**Example:**

```bash
sc-pick
# (fuzzy-search "nginx" → Enter → status pane)
```

### `sc-tail <service> [count=50]`

Tail the journal for a single unit.

**Arguments:**

| Arg  | Required | Default | Description                          |
| ---- | -------- | ------- | ------------------------------------ |
| `$1` | Yes      | —       | Unit name (e.g. `nginx`, `sshd`).    |
| `$2` | No       | `50`    | Number of recent entries to print.   |

**Behavior:**

Wraps `journalctl -u "$1" -n "${2:-50}" --no-pager`. Prints a usage line and returns 1 when no unit is given.

**Example:**

```bash
sc-tail nginx          # last 50 lines
sc-tail nginx 200      # last 200 lines
```

### `sc-failed`

List every unit in the `failed` state in a fixed-width table.

**Arguments:** none.

**Behavior:**

Calls `systemctl list-units --state=failed --no-legend`, then uses `awk` to print the unit name in a 40-char column followed by its description (the remainder of each line with the leading state columns dropped). Prints nothing when no units are failed.

**Example:**

```bash
sc-failed
# nginx.service                       A high performance web server
```

### `sc-blame [count=20]`

Show the top time-consuming units at boot.

**Arguments:**

| Arg  | Required | Default | Description                  |
| ---- | -------- | ------- | ---------------------------- |
| `$1` | No       | `20`    | How many rows to keep.       |

**Behavior:**

Pipes `systemd-analyze blame` through `head -n "${1:-20}"`. Stderr from `systemd-analyze` is suppressed so it is harmless on systems where the call would otherwise complain.

**Example:**

```bash
sc-blame           # top 20 slowest units
sc-blame 5         # top 5
```

### `sc-reboot-needed`

Heuristically check whether the host wants a reboot.

**Arguments:** none.

**Behavior:**

1. If `/var/run/reboot-required` exists (Debian/Ubuntu convention), print the warning plus the contents of `/var/run/reboot-required.pkgs` when present and return 0.
2. Otherwise compare the running kernel (`uname -r`) against the most recently installed kernel:
   - `dnf` detected → query `rpm -q --last kernel`.
   - `dpkg` detected → query `dpkg -l | awk '/linux-image-[0-9]/'`.
3. If the installed kernel string does not contain the running version, print both and recommend a reboot; otherwise print `No reboot needed`.

**Example:**

```bash
sc-reboot-needed
# Kernel: running=6.7.4-200.fc39.x86_64 installed=6.7.6-200.fc39.x86_64
# Reboot recommended
```

## REQUIREMENTS

- `systemctl` on `$PATH` (module no-ops otherwise).
- `fzf` for `sc-pick`.
- `journalctl` for `sc-tail`.
- `systemd-analyze` for `sc-blame`.
- One of `dnf`/`rpm` or `dpkg` for `sc-reboot-needed` fallback.

## EXAMPLES

```bash
sc-pick                # fuzzy-pick a unit, view its status
sc-tail sshd 100       # last 100 sshd log lines
sc-failed              # quick audit of broken units
sc-blame 10            # what slowed down this boot?
sc-reboot-needed       # is the kernel out of date?
```

## SEE ALSO

- [.docs/aliases/systemd](../aliases/systemd.md)
- [.docs/plugins/zsh/systemd](../plugins/zsh/systemd.md)
- [.docs/README.md](../README.md)
