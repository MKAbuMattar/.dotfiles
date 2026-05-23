# terraform-utils

## NAME

**terraform-utils** — Prompt helpers for the active Terraform workspace and CLI version.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "terraform" ...)
```

## DESCRIPTION

Returns silently when `terraform` is not on PATH. Defines two prompt-info functions that surface the currently selected Terraform workspace and the installed `terraform` binary's version. Both wrap their output in theme-overridable prefix/suffix tokens so they can be dropped directly into `PROMPT`/`RPROMPT`.

## FUNCTIONS

### `tf_prompt_info`

Echoes the active Terraform workspace, suppressing the default `default` workspace in `$HOME`.

**Behavior:**

Returns silently when `$PWD` equals `$HOME` (the common "you're not in a Terraform project" case). Returns silently unless `${TF_DATA_DIR:-.terraform}` exists as a directory and `${TF_DATA_DIR:-.terraform}/environment` is readable. Reads the workspace name from that file (`workspace="$(< ...)"`) and emits `${ZSH_THEME_TF_PROMPT_PREFIX-[}<workspace>${ZSH_THEME_TF_PROMPT_SUFFIX-]}`. The workspace name is percent-escaped via `:gs/%/%%` so literal `%` characters do not break prompt expansion.

**Example:**

```bash
RPROMPT='$(tf_prompt_info)'
```

### `tf_version_prompt_info`

Echoes the installed Terraform version.

**Behavior:**

Captures the first line of `terraform --version`, takes the second whitespace-separated field via `cut -d ' ' -f 2`, and emits `${ZSH_THEME_TF_VERSION_PROMPT_PREFIX-[}<version>${ZSH_THEME_TF_VERSION_PROMPT_SUFFIX-]}`. Unlike `tf_prompt_info`, this runs even outside a Terraform project and even when no workspace is selected, because it only reflects the CLI itself.

**Example:**

```bash
PROMPT='%n@%m %~ $(tf_version_prompt_info)$ '
```

## REQUIREMENTS

- `terraform` (module returns silently otherwise).
- A Terraform-initialized directory (`terraform init` having created `${TF_DATA_DIR:-.terraform}/environment`) for `tf_prompt_info`.

## EXAMPLES

```bash
# Show the workspace next to the path, version on the right
PROMPT='%~ $(tf_prompt_info)$ '
RPROMPT='$(tf_version_prompt_info)'
```

## SEE ALSO

- [.docs/aliases/terraform](../aliases/terraform.md)
- [.docs/plugins/zsh/terraform](../plugins/zsh/terraform.md)
- [.docs/README.md](../README.md)
