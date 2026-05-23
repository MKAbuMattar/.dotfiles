# aws-plugin

## NAME

**aws-plugin** — AWS profile and region switchers, prompt segment, and CLI
completion wiring.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "aws" ...)
```

## DESCRIPTION

The richest plugin in this collection. It provides:

- **Profile/region helpers** — `agp`, `agr`, `asp`, `asr`, `acp`, and
  `aws_change_access_key` for inspecting and switching the active AWS profile
  and region, including SSO login/logout and full
  `sts assume-role` / `sts get-session-token` flows with optional MFA.
- **Discovery helpers** — `aws_profiles` enumerates profiles from
  `aws configure list-profiles` (or by grepping `$AWS_CONFIG_FILE`), and
  `aws_regions` calls `aws ec2 describe-regions` to list regions.
- **`compctl`-based completion** for `asp`, `asr`, `acp`, and
  `aws_change_access_key` so they tab-complete profiles and regions.
- **A prompt segment** — `aws_prompt_info` prints `<aws:PROFILE> <region:REGION>`
  using the `ZSH_THEME_AWS_*` variables, and the plugin appends it to
  `RPROMPT` unless `SHOW_AWS_PROMPT=false`.
- **Optional persisted state** — when `AWS_PROFILE_STATE_ENABLED=true`,
  `_aws_update_state` and `_aws_clear_state` mirror the current profile/region
  to `AWS_STATE_FILE` (default `/tmp/.aws_current_profile`), and the plugin
  restores them on shell start.
- **CLI completion** — uses the AWS CLI v2 `aws_completer` via `bashcompinit`
  if available; otherwise tries `aws_zsh_completer.sh` from `$PATH`, Homebrew,
  Ubuntu `vendor-completions`, NixOS, or the RPM path.

## EFFECTS

- Returns immediately if `aws` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Defines the functions listed below.
- Registers `compctl -K _aws_regions asr` and
  `compctl -K _aws_profiles asp acp aws_change_access_key`.
- If `SHOW_AWS_PROMPT` is not `false` and `RPROMPT` doesn't already include it,
  prepends `$(aws_prompt_info)` to `RPROMPT`.
- If `AWS_PROFILE_STATE_ENABLED=true` and `$AWS_STATE_FILE` is non-empty,
  restores `AWS_DEFAULT_PROFILE`, `AWS_PROFILE`, `AWS_EB_PROFILE`,
  `AWS_REGION`, and `AWS_DEFAULT_REGION` from it.
- Wires up `aws` CLI completion via `complete -C aws_completer aws` (AWS CLI
  v2) or by sourcing the first available `aws_zsh_completer.sh`.

## FUNCTIONS

| Function                                      | Purpose                                                                                                                                                                                                                                                                                                                           |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `agp`                                         | Print the current `$AWS_PROFILE`.                                                                                                                                                                                                                                                                                                 |
| `agr`                                         | Print the current `$AWS_REGION`.                                                                                                                                                                                                                                                                                                  |
| `asp [profile] [login\|logout] [sso-session]` | Set `AWS_PROFILE` / `AWS_DEFAULT_PROFILE` / `AWS_EB_PROFILE` / `AWS_PROFILE_REGION`. With `login`, additionally runs `aws sso login` (optionally with `--sso-session`). With `logout`, runs `aws sso logout`. No argument clears the profile. Validates against `aws_profiles`.                                                   |
| `asr [region]`                                | Set `AWS_REGION` and `AWS_DEFAULT_REGION` after validating against `aws_regions`. No argument clears them.                                                                                                                                                                                                                        |
| `acp [profile] [mfa_token]`                   | "Change profile" — like `asp` but also runs `sts assume-role` (if `role_arn` is configured) or `sts get-session-token`, exporting the returned access key, secret, and session token. Prompts for the MFA code and session duration when `mfa_serial` is set and they aren't supplied. Honors `external_id` and `source_profile`. |
| `aws_change_access_key <profile>`             | Switches to `<profile>`, creates a new IAM access key, prompts to disable the previous key.                                                                                                                                                                                                                                       |
| `aws_profiles`                                | List profiles via `aws configure list-profiles`, falling back to grepping `$AWS_CONFIG_FILE`.                                                                                                                                                                                                                                     |
| `aws_regions`                                 | List regions via `aws ec2 describe-regions` using the current region/profile (defaults to `us-west-1`).                                                                                                                                                                                                                           |
| `aws_prompt_info`                             | Build the `<aws:…> <region:…>` prompt segment using `ZSH_THEME_AWS_*` variables.                                                                                                                                                                                                                                                  |
| `_aws_update_state` / `_aws_clear_state`      | Internal helpers that write/clear `$AWS_STATE_FILE` when `AWS_PROFILE_STATE_ENABLED=true`.                                                                                                                                                                                                                                        |
| `_aws_regions` / `_aws_profiles`              | `compctl` callbacks.                                                                                                                                                                                                                                                                                                              |

## ENVIRONMENT

| Variable                                                          | Read/Set                 | Default                     | Purpose                                              |
| ----------------------------------------------------------------- | ------------------------ | --------------------------- | ---------------------------------------------------- |
| `ZSH_CACHE_DIR`                                                   | Read (defaulted)         | `$HOME/.cache/zsh`          | Completion cache directory.                          |
| `AWS_PROFILE`, `AWS_DEFAULT_PROFILE`, `AWS_EB_PROFILE`            | Set/unset by `asp`/`acp` | —                           | Active AWS profile.                                  |
| `AWS_REGION`, `AWS_DEFAULT_REGION`                                | Set/unset by `asr`/`acp` | —                           | Active AWS region.                                   |
| `AWS_PROFILE_REGION`                                              | Set by `asp`             | —                           | Region pulled from `aws configure get region`.       |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` | Set/unset by `acp`       | —                           | Temporary credentials from `sts`.                    |
| `AWS_CONFIG_FILE`                                                 | Read                     | `$HOME/.aws/config`         | Used by `aws_profiles` fallback.                     |
| `AWS_PROFILE_STATE_ENABLED`                                       | Read                     | unset                       | Enables state-file persistence when `true`.          |
| `AWS_STATE_FILE`                                                  | Read/Set                 | `/tmp/.aws_current_profile` | Path of the state file.                              |
| `SHOW_AWS_PROMPT`                                                 | Read                     | unset                       | Set to `false` to skip injecting the prompt segment. |
| `RPROMPT`                                                         | Modified                 | —                           | Prepended with `$(aws_prompt_info)`.                 |
| `ZSH_THEME_AWS_PROFILE_PREFIX` / `_SUFFIX`                        | Read                     | `<aws:` / `>`               | Decoration for the profile segment.                  |
| `ZSH_THEME_AWS_REGION_PREFIX` / `_SUFFIX`                         | Read                     | `<region:` / `>`            | Decoration for the region segment.                   |
| `ZSH_THEME_AWS_DIVIDER`                                           | Read                     | ` `                         | Separator between profile and region.                |

## FILES

| Path                                                    | Role                                                    |
| ------------------------------------------------------- | ------------------------------------------------------- |
| `$AWS_CONFIG_FILE` (default `$HOME/.aws/config`)        | Source of profiles for `aws_profiles` fallback.         |
| `$AWS_STATE_FILE` (default `/tmp/.aws_current_profile`) | Persists `"PROFILE REGION"` when state mode is enabled. |
| `aws_completer` (on `$PATH`)                            | Preferred AWS CLI v2 completer.                         |
| `aws_zsh_completer.sh` (various locations)              | Fallback completer for AWS CLI v1.                      |

## REQUIREMENTS

- `aws` CLI on `$PATH`. The plugin no-ops otherwise.
- `aws_completer` (AWS CLI v2) is recommended; otherwise an `aws_zsh_completer.sh`
  must be discoverable for tab completion to load.

## SEE ALSO

- [.docs/README.md](../../README.md)
