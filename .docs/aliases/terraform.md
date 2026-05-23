# terraform-aliases

## NAME

**terraform-aliases** — short aliases for `terraform` init/plan/apply/destroy/state/workspace operations.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "terraform" ...)
```

## DESCRIPTION

Provides short `tf*` aliases for `terraform` core workflow commands — init (with reconfigure/upgrade), plan, apply (with auto-approve and parallelism control), destroy, format (recursive), validate, console, output, show, test, state, and workspace list/select. The module is gated by `(( ! $+commands[terraform] )) && return`, so it loads only when `terraform` is on `$PATH`.

The `!`-suffixed aliases (`tfa!`, `tfd!`) require zsh's history-expansion to be off in that position (they're plain alias names that happen to contain `!`); in interactive shells with `setopt nobanghist` or `setopt nohistexpand` they work without escaping.

## ALIASES

### Core

| Alias | Expansion   | Description   |
| ----- | ----------- | ------------- |
| `tf`  | `terraform` | Run terraform |

### Init

| Alias   | Expansion                              | Description                        |
| ------- | -------------------------------------- | ---------------------------------- |
| `tfi`   | `terraform init`                       | Initialize the working directory   |
| `tfir`  | `terraform init -reconfigure`          | Init, reconfiguring backend        |
| `tfiu`  | `terraform init -upgrade`              | Init and upgrade modules/providers |
| `tfiur` | `terraform init -upgrade -reconfigure` | Init with upgrade + reconfigure    |

### Plan / Apply / Destroy

| Alias  | Expansion                          | Description                       |
| ------ | ---------------------------------- | --------------------------------- |
| `tfp`  | `terraform plan`                   | Plan changes                      |
| `tfa`  | `terraform apply`                  | Apply changes                     |
| `tfa!` | `terraform apply -auto-approve`    | Apply without confirmation        |
| `tfap` | `terraform apply -parallelism=1`   | Apply serially (`-parallelism=1`) |
| `tfd`  | `terraform destroy`                | Destroy managed resources         |
| `tfd!` | `terraform destroy -auto-approve`  | Destroy without confirmation      |
| `tfdp` | `terraform destroy -parallelism=1` | Destroy serially                  |

### Format / Validate / Test

| Alias  | Expansion                  | Description                 |
| ------ | -------------------------- | --------------------------- |
| `tff`  | `terraform fmt`            | Format files in current dir |
| `tffr` | `terraform fmt -recursive` | Format recursively          |
| `tfv`  | `terraform validate`       | Validate configuration      |
| `tft`  | `terraform test`           | Run `terraform test`        |

### Inspect

| Alias  | Expansion           | Description               |
| ------ | ------------------- | ------------------------- |
| `tfc`  | `terraform console` | Interactive console       |
| `tfo`  | `terraform output`  | Show outputs              |
| `tfsh` | `terraform show`    | Show current state / plan |
| `tfs`  | `terraform state`   | State subcommands         |

### Workspace

| Alias  | Expansion                    | Description           |
| ------ | ---------------------------- | --------------------- |
| `tfw`  | `terraform workspace`        | Workspace subcommands |
| `tfwl` | `terraform workspace list`   | List workspaces       |
| `tfws` | `terraform workspace select` | Select a workspace    |

## REQUIREMENTS

- `terraform` installed and on `$PATH`.

## EXAMPLES

```bash
# Initialize and plan a module
tfiu
tfp

# Apply without prompting (in CI)
tfa!

# Switch workspaces
tfwl
tfws staging

# Format every Terraform file under cwd
tffr
```

## SEE ALSO

- [.docs/plugins/zsh/terraform](../plugins/zsh/terraform.md)
- [.docs/README.md](../README.md)
