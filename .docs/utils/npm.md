# npm-utils

## NAME

**npm-utils** — Key-bound ZLE widget that toggles `npm install` and `npm uninstall`.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "npm" ...)
```

## DESCRIPTION

Returns silently when `npm` is not on PATH. Registers a single ZLE widget, `npm_toggle_install_uninstall`, and binds it to the double-tap F2 sequence (`^[OQ^[OQ`) in the `emacs`, `vicmd`, and `viins` keymaps. The widget rewrites the current command line (or the most recent two history entries) by swapping `install` ↔ `uninstall`, expanding short aliases (`i`, `un`) along the way. When nothing matches it primes the buffer with `npm install`.

## FUNCTIONS

### `npm_toggle_install_uninstall`

ZLE widget — swap `install` and `uninstall` on the current command.

**Behavior:**

Iterates over three candidate lines in order: the current `$BUFFER`, then `$history[$((HISTCMD-1))]`, then `$history[$((HISTCMD-2))]`. For each, matches:

| Pattern             | Rewrite             | Cursor adjust |
| ------------------- | ------------------- | ------------- |
| `npm uninstall ...` | `npm install ...`   | `CURSOR += 2` |
| `npm install ...`   | `npm uninstall ...` | `CURSOR += 2` |
| `npm un ...`        | `npm install ...`   | `CURSOR += 5` |
| `npm i ...`         | `npm uninstall ...` | `CURSOR += 8` |

On the first hit the buffer is replaced and the widget returns 0. If none of the three lines match, `$BUFFER` is set to `npm install` and the cursor is moved to the end.

**Behavior (registration):**

After the function body, the file runs:

- `zle -N npm_toggle_install_uninstall` to register it as a widget.
- `bindkey -M emacs '^[OQ^[OQ' npm_toggle_install_uninstall`
- `bindkey -M vicmd '^[OQ^[OQ' npm_toggle_install_uninstall`
- `bindkey -M viins '^[OQ^[OQ' npm_toggle_install_uninstall`

The escape sequence `^[OQ` corresponds to F2 on most terminals, so the binding is "F2, F2" in quick succession.

**Example:**

```text
$ npm install lodash       # press F2 F2 →
$ npm uninstall lodash
```

## REQUIREMENTS

- `npm` on PATH (module no-ops otherwise).
- A terminal whose F2 produces the `^[OQ` sequence. Adjust `bindkey` lines if your terminal differs.

## EXAMPLES

```bash
# Hit F2 F2 with the cursor anywhere on the line:
npm i react        # → npm uninstall react
npm uninstall axios # → npm install axios
```

## SEE ALSO

- [.docs/aliases/npm](../aliases/npm.md)
- [.docs/plugins/zsh/npm](../plugins/zsh/npm.md)
- [.docs/README.md](../README.md)
