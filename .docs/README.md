# Dotfiles Reference Documentation

AWS-style man pages for every shell script, alias module, zsh plugin, and Python
plugin in this repository. Each page is self-contained — open the one you need
from the index below.

> Format conventions (each page):
>
> - **NAME** — module identifier and one-line summary
> - **SYNOPSIS** — how to invoke / source / enable
> - **DESCRIPTION** — extended prose
> - **COMMANDS / ALIASES / FUNCTIONS / OPTIONS** — the meat (table form)
> - **EXAMPLES** — copy-pasteable real usage
> - **OUTPUT** — what the user sees
> - **EXIT STATUS** — for executables and CLI tools
> - **ENVIRONMENT** — relevant env vars
> - **FILES** — touched or referenced files
> - **PLATFORMS** — Linux / macOS / Windows support matrix
> - **SEE ALSO** — sibling docs

---

## Bootstrap

| Page                 | Description                                             |
| -------------------- | ------------------------------------------------------- |
| [setup](../setup.md) | Bootstraps symlinks and gitconfig includes into `$HOME` |

## Python Plugins

CLI tools shipped under `.plugins/.python/` — each is a runnable command.

| Page                                                   | Command        | Description                                 |
| ------------------------------------------------------ | -------------- | ------------------------------------------- |
| [base64](plugins/python/base64.md)                     | `base64`       | Base64 encode/decode text and files         |
| [clock](plugins/python/clock.md)                       | `clock`        | Terminal countdown / stopwatch / wall clock |
| [matrix](plugins/python/matrix.md)                     | `matrix`       | "The Matrix" rain animation                 |
| [prayer-times](plugins/python/prayer-times.md)         | `prayer-times` | Prayer times by city via AlAdhan API        |
| [qrcode](plugins/python/qrcode.md)                     | `qrcode`       | QR-code generator via qrcode.show           |
| [random-quote](plugins/python/random-quote.md)         | `random-quote` | Random quote via Quotable API               |
| [weather-forecast](plugins/python/weather-forecast.md) | `weather`      | Weather + moon-phase via wttr.in            |
| [web-search](plugins/python/web-search.md)             | `web-search`   | Open browser searches for 25+ engines       |

## Zsh Aliases (`.aliases/`)

Per-tool alias modules. Enable by adding the topic name to the `ALIASES` array
in `~/.zshrc`. See [`.docs/aliases/`](aliases/) for the full set.

## Zsh Utilities (`.utils/`)

Per-tool function libraries. Enable via the `UTILS` array in `~/.zshrc`.
See [`.docs/utils/`](utils/).

## Zsh Plugins (`.plugins/.zsh/`)

Tool integrations (completion wiring, env setup, key bindings). Enable via the
`PLUGINS` array in `~/.zshrc`. Five vendored upstream plugins (`fzf`,
`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-history-substring-search`,
`pyenv`) are intentionally undocumented — refer to the upstream projects.
See [`.docs/plugins/zsh/`](plugins/zsh/).

## Zsh Core (`.zsh/`)

| File                   | Page                                            |
| ---------------------- | ----------------------------------------------- |
| `.zsh/options.zsh`     | [zsh-core/options](zsh-core/options.md)         |
| `.zsh/completion.zsh`  | [zsh-core/completion](zsh-core/completion.md)   |
| `.zsh/keybindings.zsh` | [zsh-core/keybindings](zsh-core/keybindings.md) |
