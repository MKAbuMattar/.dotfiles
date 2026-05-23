# exa-aliases

## NAME

**exa-aliases** — drop-in `ls` replacements backed by `exa`.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "exa" ...)
```

## DESCRIPTION

Overrides the standard `ls`, `la`, `ll`, and `lt` (plus the dotfile-only
`l.`) shortcuts to call `exa` with sensible defaults: colours always on,
directories grouped first, file-type icons enabled. The icons require a
Nerd-Font in your terminal — without one you'll see tofu. `exa` itself is
no longer maintained upstream; consider its fork `eza` if you want fresh
releases (you can simply `alias exa=eza` before this module loads).

## ALIASES

### Listing

| Alias | Expansion                                                  | Description                            |
| ----- | ---------------------------------------------------------- | -------------------------------------- |
| `ls`  | `eza -al --color=always --group-directories-first --icons` | Long listing including hidden entries. |
| `la`  | `eza -a --color=always --group-directories-first --icons`  | Plain listing including hidden.        |
| `ll`  | `eza -l --color=always --group-directories-first --icons`  | Long listing without hidden.           |
| `lt`  | `eza -aT --color=always --group-directories-first --icons` | Recursive tree, hidden included.       |
| `l.`  | `eza -a \| egrep "^\."`                                    | Show only dotfiles in cwd.             |

## REQUIREMENTS

- `exa` (or `eza`, aliased to `exa`) on `$PATH`.
- A Nerd-Font configured in the terminal for the `--icons` glyphs to render.

## EXAMPLES

```bash
ls                 # long, with icons
lt -L 2            # tree two levels deep
l.                 # dotfiles only
```

## SEE ALSO

- [.docs/README.md](../README.md)
