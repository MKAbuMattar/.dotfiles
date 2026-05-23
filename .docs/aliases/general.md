# general-aliases

## NAME

**general-aliases** — catch-all module for one-off shortcuts that don't belong anywhere else.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "general" ...)
```

## DESCRIPTION

A grab-bag module currently holding a single alias for the AntiGravity text
editor. Treat this file as the place to drop personal one-off aliases that
don't justify a dedicated module of their own.

## ALIASES

### Editors

| Alias | Expansion     | Description                         |
| ----- | ------------- | ----------------------------------- |
| `ag`  | `antigravity` | Launch the AntiGravity text editor. |

> Heads-up: `ag` collides with the very popular [The Silver
> Searcher](https://github.com/ggreer/the_silver_searcher) (also `ag`). If
> you rely on Silver Searcher, omit `"general"` from your `ALIASES` array
> or rename this alias locally.

## REQUIREMENTS

- `antigravity` binary on `$PATH`.

## EXAMPLES

```bash
ag path/to/file
```

## SEE ALSO

- [.docs/README.md](../README.md)
