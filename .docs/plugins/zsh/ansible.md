# ansible-plugin

## NAME

**ansible-plugin** — helper functions and basic completion for Ansible.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "ansible" ...)
```

## DESCRIPTION

Provides two small helper functions (`ansible-version` and `ansible-role-init`)
and installs a minimal zsh `_ansible` completion file under
`$ZSH_CACHE_DIR/completions/`. The completion covers the most common
subcommands (`ansible`, `ansible-playbook`, `ansible-vault`, `ansible-galaxy`,
`ansible-config`, `ansible-console`, `ansible-doc`, `ansible-inventory`,
`ansible-pull`) with basic argument hints — it is intentionally lightweight
rather than exhaustive. The file is regenerated when it is missing or older
than seven days.

## EFFECTS

- Returns immediately if `ansible` is not on `$PATH`.
- Defines `ansible-version` and `ansible-role-init`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Writes a static `_ansible` completion script if the cached copy is missing or
  older than 7 days.

## FUNCTIONS

| Function                   | Purpose                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `ansible-version`          | Prints `ansible --version`.                                                                                                       |
| `ansible-role-init <role>` | Runs `ansible-galaxy init <role>` and then `tree <role>` to show the layout. Prints a usage hint when called without an argument. |

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                                  | Role                                                               |
| ------------------------------------- | ------------------------------------------------------------------ |
| `$ZSH_CACHE_DIR/completions/_ansible` | Minimal hand-written completion shared by all `ansible*` commands. |

## REQUIREMENTS

- `ansible` on `$PATH`. The plugin no-ops otherwise.
- `ansible-galaxy` and `tree` for `ansible-role-init`.

## SEE ALSO

- [.docs/aliases/ansible.md](../../aliases/ansible.md)
- [.docs/README.md](../../README.md)
