# ripgrep-aliases

## NAME

**ripgrep-aliases** — concise shortcuts for the most-used `rg` flag combinations.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "ripgrep" ...)
```

## DESCRIPTION

`rg` already runs at memorable defaults — these aliases just remove the
flag noise from the calls you make most often: case-insensitive search,
including hidden + ignored files, smart-case, count-only, files-only,
whole-word, type-filtered, with context, and JSON output. The module
no-ops if `rg` is not on PATH.

## ALIASES

### Case + filtering

| Alias  | Expansion                | Description                                     |
| ------ | ------------------------ | ----------------------------------------------- |
| `rgi`  | `rg -i`                  | Case-insensitive search.                        |
| `rgs`  | `rg --smart-case`        | Case-sensitive only when the query has uppercase. |
| `rgw`  | `rg -w`                  | Whole-word matches only.                        |
| `rgh`  | `rg --hidden --no-ignore` | Search hidden files and ignore `.gitignore`.    |

### Output shaping

| Alias    | Expansion              | Description                                  |
| -------- | ---------------------- | -------------------------------------------- |
| `rgc`    | `rg --count-matches`   | Print match counts per file.                 |
| `rgl`    | `rg --files-with-matches` | Print only the filenames that contain a match. |
| `rgctx`  | `rg -C 3`              | Show 3 lines of context above and below.     |
| `rgjson` | `rg --json`            | Machine-readable JSONL output (jq-friendly). |

### Type filter

| Alias | Expansion    | Description                                  |
| ----- | ------------ | -------------------------------------------- |
| `rgf` | `rg --type`  | Restrict to a file type, e.g. `rgf py foo`.  |

## REQUIREMENTS

- `rg` (ripgrep) on PATH (Debian/Ubuntu: `apt install ripgrep`).
- For `rgjson`: `jq` to consume the JSONL stream.

## EXAMPLES

```bash
rgi TODO                       # case-insensitive search for TODO
rgh password                   # also search hidden / gitignored files
rgf py "def main"              # only Python files
rgjson http | jq '.data.lines' # post-process matches with jq
```

## SEE ALSO

- [.docs/plugins/zsh/ripgrep](../plugins/zsh/ripgrep.md) — exports `RIPGREP_CONFIG_PATH`
- [.docs/README.md](../README.md)
