# screen-plugin

## NAME

**screen-plugin** — placeholder stub that only verifies the `screen`
binary is installed.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "screen" ...)
```

## DESCRIPTION

This plugin is intentionally a no-op past the existence check. It
returns immediately if `screen` is not on PATH and otherwise does
nothing else inside the shell. Companion functionality lives in the
`screen` alias bundle and the `screen` util bundle.

The slot is reserved so that future completion or environment glue can
be added without renaming the plugin entry in `~/.zshrc`.

## EFFECTS

- Returns immediately if `screen` is not on PATH.
- Otherwise performs no side effects.

## FUNCTIONS

None.

## ENVIRONMENT

None.

## FILES

- `.plugins/.zsh/screen/screen.plugin.zsh` — the plugin source.

## REQUIREMENTS

- A working `screen` binary on PATH (only as a guard).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/screen](../../aliases/screen.md)
- [.docs/utils/screen](../../utils/screen.md)
- [.docs/README.md](../../README.md)
