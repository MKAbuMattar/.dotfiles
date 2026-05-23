# copybuffer-plugin

## NAME

**copybuffer-plugin** — bind a key to copy the current command-line buffer to
the system clipboard.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "copybuffer" ...)
```

## DESCRIPTION

Defines a single ZLE widget, `copybuffer`, that pipes the current `$BUFFER`
into the `clipcopy` helper (typically provided by another plugin or shipped
alongside `oh-my-zsh`-style toolkits). The widget is bound to `Ctrl-O` in the
`emacs`, `viins`, and `vicmd` keymaps. If `clipcopy` is not found at invocation
time, the widget shows a message in the line editor and does nothing.

## EFFECTS

- Defines the `copybuffer` shell function.
- Registers it as a ZLE widget with `zle -N copybuffer`.
- Binds `Ctrl-O` to `copybuffer` in keymaps `emacs`, `viins`, and `vicmd`.

## FUNCTIONS

| Function     | Purpose                                                                                                                                       |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `copybuffer` | If `clipcopy` exists, pipes `$BUFFER` to it; otherwise displays `"clipcopy not found. Please make sure you have it installed."` via `zle -M`. |

## KEY BINDINGS

| Keymap  | Key             | Action            |
| ------- | --------------- | ----------------- |
| `emacs` | `Ctrl-O` (`^O`) | Run `copybuffer`. |
| `viins` | `Ctrl-O` (`^O`) | Run `copybuffer`. |
| `vicmd` | `Ctrl-O` (`^O`) | Run `copybuffer`. |

## REQUIREMENTS

- A `clipcopy` command available at the time `Ctrl-O` is pressed (typically a
  wrapper around `xclip`, `wl-copy`, `pbcopy`, etc.).

## SEE ALSO

- [.docs/README.md](../../README.md)
