# bat-aliases

## NAME

**bat-aliases** — colourised `cat`/`less` replacements backed by `bat`.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "bat" ...)
```

## DESCRIPTION

Overrides `cat` and `less` to call `bat` with sensible defaults (no paging
for `cat`, paged output for `less`) and provides a small family of language-
specific shortcuts (`bjson`, `byaml`, `btoml`, `bmd`) for pretty-printing
piped input. The module auto-detects whether the binary is named `bat`
(Fedora, Arch, macOS) or `batcat` (Debian/Ubuntu) and exports the chosen
name as `$BAT_BIN` for use in the alias definitions; it no-ops if neither
is present.

## ALIASES

### Pagers / replacements

| Alias  | Expansion                | Description                              |
| ------ | ------------------------ | ---------------------------------------- |
| `cat`  | `$BAT_BIN --paging=never` | Drop-in syntax-highlighted `cat`.        |
| `less` | `$BAT_BIN --paging=always` | Pager with `bat`'s themes + line numbers. |
| `bcat` | `$BAT_BIN`               | Raw `bat` with default paging behaviour. |

### Style variants

| Alias    | Expansion                              | Description                              |
| -------- | -------------------------------------- | ---------------------------------------- |
| `bplain` | `$BAT_BIN --style=plain --paging=never` | No headers / line numbers — clean copy.  |
| `bnum`   | `$BAT_BIN --style=numbers`             | Show line numbers only, no header bar.   |

### Language shortcuts

| Alias   | Expansion                          | Description                              |
| ------- | ---------------------------------- | ---------------------------------------- |
| `bjson` | `$BAT_BIN -l json --paging=never`  | Pretty-print stdin as JSON.              |
| `byaml` | `$BAT_BIN -l yaml --paging=never`  | Pretty-print stdin as YAML.              |
| `btoml` | `$BAT_BIN -l toml --paging=never`  | Pretty-print stdin as TOML.              |
| `bmd`   | `$BAT_BIN -l md`                   | Render Markdown (paged).                 |

## ENVIRONMENT

| Variable   | Set | Purpose                                                            |
| ---------- | --- | ------------------------------------------------------------------ |
| `BAT_BIN`  | Yes | Resolved binary name: `bat` on Fedora/Arch/macOS, `batcat` on Debian/Ubuntu. |

## REQUIREMENTS

- `bat` binary on PATH (Debian/Ubuntu ship it as `batcat` — both are
  detected automatically).
- Module returns early if neither is installed.

## EXAMPLES

```bash
cat ~/.zshrc                     # highlighted, no pager
less /var/log/syslog             # paged, themed
curl -s api.example.com | bjson  # pretty JSON
kubectl get pod -o yaml | byaml  # pretty YAML
```

## SEE ALSO

- [.docs/plugins/zsh/bat](../plugins/zsh/bat.md) — sets `BAT_THEME`, `BAT_STYLE`, `MANPAGER`
- [.docs/README.md](../README.md)
