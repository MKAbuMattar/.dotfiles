# vscode-plugin

## NAME

**vscode-plugin** — probes the local system for a VS Code flavour and
exports `VSCODE` to the chosen binary name.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "vscode" ...)
```

## DESCRIPTION

The Visual Studio Code ecosystem ships under several command names —
`code` (stable), `code-insiders`, `codium` (VSCodium), and `cursor`.
This plugin lets the rest of the dotfiles refer to "the editor" via a
single variable, `$VSCODE`, by detecting which binary is installed.

Behaviour:

1. If the user already exported `VSCODE` but the named binary cannot
   be found via `which`, the plugin prints a warning and clears
   `VSCODE` so the auto-probe runs.
2. The auto-probe checks `code`, then `code-insiders`, then `codium`,
   then `cursor`, stopping at the first match.
3. If none are found the plugin `return`s without exporting anything,
   leaving `VSCODE` unset.
4. Otherwise `VSCODE` is exported with the discovered command name.

Aliases and shell helpers elsewhere in the dotfiles can then invoke
`$VSCODE` regardless of which flavour the user installed.

## EFFECTS

- If `VSCODE` is set to an unfound command, prints
  `'<value>' flavour of VS Code not detected.` and `unset`s it.
- When `VSCODE` is unset, probes `code`, `code-insiders`, `codium`,
  `cursor` in that order.
- Returns without modifying the environment when none of the four
  binaries is on PATH.
- Otherwise `export VSCODE=<chosen>`.

## FUNCTIONS

None.

## ENVIRONMENT

- `VSCODE` — input _and_ output. May be pre-set by the user to force a
  specific flavour. After load it contains the resolved command name
  (`code`, `code-insiders`, `codium`, or `cursor`).

## FILES

- `.plugins/.zsh/vscode/vscode.plugin.zsh` — the plugin source.

## REQUIREMENTS

- At least one of `code`, `code-insiders`, `codium`, or `cursor` on
  PATH (otherwise the plugin is a silent no-op).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/vscode](../../aliases/vscode.md)
- [.docs/README.md](../../README.md)
