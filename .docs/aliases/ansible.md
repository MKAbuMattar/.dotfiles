# ansible-aliases

## NAME

**ansible-aliases** — short prefixes for the Ansible CLI suite.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "ansible" ...)
```

## DESCRIPTION

This module exposes one- to seven-character shortcuts for the common Ansible
binaries (`ansible`, `ansible-playbook`, `ansible-galaxy`, `ansible-vault`,
etc.). Each alias keeps a trailing space so the next token completes against
the wrapped command's own arguments. No sudo gating and no helper detection —
the aliases load unconditionally and assume Ansible is on `$PATH`.

## ALIASES

### Core CLI

| Alias       | Expansion            | Description                                |
| ----------- | -------------------- | ------------------------------------------ |
| `a`         | `ansible `           | Ad-hoc command runner.                     |
| `aconf`     | `ansible-config `    | View / dump configuration.                 |
| `acon`      | `ansible-console `   | REPL for ad-hoc tasks.                     |
| `aver`      | `ansible-version`    | Print Ansible version (no trailing space). |
| `arinit`    | `ansible-role-init`  | Scaffold a new role (custom binary).       |
| `aplaybook` | `ansible-playbook `  | Run a playbook.                            |
| `ainv`      | `ansible-inventory ` | Inspect inventory.                         |
| `adoc`      | `ansible-doc `       | Show module / plugin docs.                 |
| `agal`      | `ansible-galaxy `    | Manage roles and collections.              |
| `apull`     | `ansible-pull `      | Pull a playbook from VCS and run it.       |
| `aval`      | `ansible-vault`      | Encrypt / decrypt secrets.                 |

## REQUIREMENTS

- `ansible` (provides `ansible`, `ansible-playbook`, `ansible-galaxy`,
  `ansible-vault`, `ansible-doc`, `ansible-inventory`, `ansible-console`,
  `ansible-config`).
- `ansible-version` and `ansible-role-init` are non-standard helpers; provide
  them yourself on `$PATH` if you intend to use `aver` / `arinit`.

## EXAMPLES

```bash
a all -m ping
aplaybook site.yml -i inventory.ini
agal collection install community.general
aval encrypt group_vars/all/secrets.yml
```

## SEE ALSO

- [.docs/README.md](../README.md)
