# zoxide-aliases

## NAME

**zoxide-aliases** — supplemental shortcuts for the `zoxide` smarter-cd database.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "zoxide" ...)
```

## DESCRIPTION

`zoxide init zsh` (run by the matching plugin) defines the primary `z` and
`zi` (interactive) commands; this module *supplements* them with quick
shortcuts for querying and editing the directory database (jump back,
list ranked entries, remove or manually add a path) without replacing the
builtin `cd`. The module no-ops if `zoxide` is not on PATH.

## ALIASES

| Alias  | Expansion                     | Description                                       |
| ------ | ----------------------------- | ------------------------------------------------- |
| `zb`   | `z -`                         | Jump back to the previous directory.              |
| `zq`   | `zoxide query`                | Print the highest-ranked entry matching a query.  |
| `zql`  | `zoxide query --list`         | List all matching entries, ranked.                |
| `zqi`  | `zoxide query --interactive`  | Same as `zi` — interactive fzf-style picker.      |
| `zr`   | `zoxide remove`               | Remove an entry by path.                          |
| `za`   | `zoxide add`                  | Manually add a directory to the database.         |

> `z` and `zi` themselves come from `zoxide init zsh` (see the plugin) — they
> are *not* aliased here.

## REQUIREMENTS

- `zoxide` binary on PATH.
- The `zoxide` plugin must also be enabled so that `z`/`zi` are defined.

## EXAMPLES

```bash
z proj          # jump to highest-ranked match for "proj"
zql kube        # list all "kube"-matching entries with their scores
zb              # back to previous dir
zr /tmp/scratch # forget that path
```

## SEE ALSO

- [.docs/plugins/zsh/zoxide](../plugins/zsh/zoxide.md) — runs `zoxide init zsh`
- [.docs/README.md](../README.md)
