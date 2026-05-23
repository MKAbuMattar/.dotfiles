# fd-aliases

## NAME

**fd-aliases** — concise filter shortcuts for the `fd` user-friendly `find` replacement.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "fd" ...)
```

## DESCRIPTION

Auto-detects whether the binary is named `fd` (Fedora, Arch, macOS) or
`fdfind` (Debian/Ubuntu, where `fd` collided with another package) and
exports the chosen name as `$FD_BIN`. When the binary is `fdfind` and no
`fd` already exists on PATH, an additional `fd → fdfind` alias is created
so scripts and muscle memory stay portable. The remaining shortcuts cover
the filters used most often: hidden files, no-ignore, by extension, by
type, exec, by size, and by mtime windows. No-ops if neither binary is
installed.

## ALIASES

### Portability shim

| Alias | Expansion | Condition                                                    |
| ----- | --------- | ------------------------------------------------------------ |
| `fd`  | `fdfind`  | Only on Debian/Ubuntu when `fd` itself isn't already on PATH. |

### Visibility / ignore rules

| Alias | Expansion              | Description                              |
| ----- | ---------------------- | ---------------------------------------- |
| `fdh` | `$FD_BIN --hidden`     | Include hidden files.                    |
| `fdH` | `$FD_BIN --hidden --no-ignore` | Hidden **and** ignore `.gitignore`. |

### Filters

| Alias   | Expansion                          | Description                                   |
| ------- | ---------------------------------- | --------------------------------------------- |
| `fde`   | `$FD_BIN --extension`              | Filter by extension: `fde py`.                |
| `fdt`   | `$FD_BIN --type`                   | Filter by type: `fdt d`, `fdt f`, `fdt l`.    |
| `fdfx`  | `$FD_BIN -t x`                     | Executables only.                             |
| `fdsz`  | `$FD_BIN --type f --size`          | Files matching a size: `fdsz +1M`.            |
| `fdold` | `$FD_BIN --type f --changed-before` | Files older than a duration: `fdold 30d`.    |
| `fdnew` | `$FD_BIN --type f --changed-within` | Files newer than a duration: `fdnew 1d`.     |

### Exec

| Alias  | Expansion        | Description                                            |
| ------ | ---------------- | ------------------------------------------------------ |
| `fdx`  | `$FD_BIN --exec` | Run a command on each match: `fdx -e py -- ruff check`. |

## ENVIRONMENT

| Variable | Set | Purpose                                                          |
| -------- | --- | ---------------------------------------------------------------- |
| `FD_BIN` | Yes | Resolved binary name: `fd` or `fdfind` depending on distribution. |

## REQUIREMENTS

- `fd` (Fedora/Arch/macOS) or `fdfind` (Debian/Ubuntu) on PATH.
- Module returns early if neither is installed.

## EXAMPLES

```bash
fde py                # all .py files under cwd
fdt d node_modules    # directories named node_modules
fdsz +10M             # files larger than 10 MB
fdnew 1d              # files modified in the last day
fdx -e log -- gzip {} # gzip every .log file
```

## SEE ALSO

- [.docs/plugins/zsh/fd](../plugins/zsh/fd.md) — completion wiring
- [.docs/README.md](../README.md)
