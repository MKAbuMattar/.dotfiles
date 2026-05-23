# gcp-plugin

## NAME

**gcp-plugin** — wires up Google Cloud SDK completion and `PATH` integration.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "gcp" ...)
```

## DESCRIPTION

Unlike most cloud-CLI plugins, the Google Cloud SDK ships its own
`completion.zsh.inc` and `path.zsh.inc` snippets. This plugin locates the SDK
under one of several well-known prefixes and, when found, sources both
snippets so that `gcloud`, `gsutil`, `bq`, and friends become available with
zsh completion. If `gcloud` is not on `$PATH` the plugin no-ops.

The locations probed (in order) are:

- `$HOME/google-cloud-sdk`
- `/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk`
- `/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk`
- `/usr/share/google-cloud-sdk`
- `/snap/google-cloud-sdk/current`
- `/usr/lib/google-cloud-sdk`
- `/opt/google-cloud-sdk`

## EFFECTS

- Returns immediately if `gcloud` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath` (kept for
  consistency; this plugin does not write into it).
- Defines an internal `_gcloud-sdk-location` function and uses it to populate
  `$GCLOUD_SDK_LOCATION`.
- Sources `$GCLOUD_SDK_LOCATION/completion.zsh.inc` if present.
- Sources `$GCLOUD_SDK_LOCATION/path.zsh.inc` if present (which prepends the
  SDK `bin/` directory to `$PATH`).
- Unsets `$GCLOUD_SDK_LOCATION` afterwards.

## FUNCTIONS

| Function               | Purpose                                                                                                          |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `_gcloud-sdk-location` | Walks the candidate list above and echoes the first directory that exists; returns non-zero if nothing is found. |

## ENVIRONMENT

| Variable              | Read/Set              | Default            | Purpose                                              |
| --------------------- | --------------------- | ------------------ | ---------------------------------------------------- |
| `ZSH_CACHE_DIR`       | Read (defaulted)      | `$HOME/.cache/zsh` | Completion cache directory (created/added to fpath). |
| `GCLOUD_SDK_LOCATION` | Set then unset        | —                  | Holds the resolved SDK path during plugin load.      |
| `PATH`                | Modified (indirectly) | —                  | Updated by the sourced `path.zsh.inc`.               |

## FILES

| Path                       | Role                                          |
| -------------------------- | --------------------------------------------- |
| `<sdk>/completion.zsh.inc` | Official zsh completion for Google Cloud SDK. |
| `<sdk>/path.zsh.inc`       | Adds the SDK to `$PATH`.                      |

## REQUIREMENTS

- `gcloud` on `$PATH`. The plugin no-ops otherwise.
- A Google Cloud SDK installation in one of the probed locations.

## SEE ALSO

- [.docs/README.md](../../README.md)
