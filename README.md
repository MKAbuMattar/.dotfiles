# dotfiles

Personal zsh-centric dotfiles: modular aliases, utility functions, completion
plugins, a small fleet of Python CLI tools, and a fully cross-referenced
man-page system so `man <module>` and `apropos <keyword>` work for everything
in here.

```text
.aliases/   — per-tool alias modules (35 modules)
.utils/     — per-tool shell function libraries (17 modules)
.plugins/   — zsh plugins (40 in-scope + 5 vendored) + 8 Python CLI plugins
.zsh/       — core zsh settings (options, completion, keybindings)
.config/    — third-party app configs (kitty, btop, mpv, …)
.docs/      — AWS-style markdown man pages (source of truth — 104 pages)
.man/       — generated roff man pages (built by .scripts/build-man-pages.py)
.scripts/   — build & maintenance scripts
.agents/    — Claude Code skills used to author this repo
setup       — one-shot bootstrap (idempotent; safe to re-run)
```

> Cross-distro package-management modules ship for: **arch / debian / fedora /
> opensuse / alpine** (aliases + utils + plugins for each).

## Quick start

```bash
git clone https://github.com/MKAbuMattar/dotfiles ~/Work/dotfiles
cd ~/Work/dotfiles
./setup
```

`setup` will:

1. Symlink the repo (or its individual subtrees) into `~/.config/.dotfiles`.
2. Symlink `~/.zshrc` to the repo's `.zshrc`.
3. Build the modular `~/.gitconfig` `[include]` block.
4. Generate the man pages and refresh the `apropos` index.
5. Verify `git` and `zsh` are installed.

Then `source ~/.zshrc` (or open a new terminal).

## Configuring what loads

Edit the arrays in [`~/.zshrc`](.zshrc) to opt in or out per module:

```zsh
UTILS=("clipboard" "fedora" "git" "npm" ...)        # shell functions
PLUGINS=("aws" "docker" "fzf" "git" "kubectl" ...)  # completion/integration
ALIASES=("docker" "exa" "general" "git" "npm" ...)  # short command aliases
```

Comment lines (`# "name"`) are honored. Reload with `source ~/.zshrc`.

## Documentation

Every alias module, util module, zsh plugin, and Python plugin has a man page
viewable two ways:

| How                            | Where                                                          |
| ------------------------------ | -------------------------------------------------------------- |
| `man <module>` in the terminal | Section 1 (commands) or section 7 (modules)                    |
| Markdown source                | [.docs/](.docs/) — start at [.docs/README.md](.docs/README.md) |
| `apropos <keyword>`            | Searches the NAME line of every page                           |

Examples:

```bash
man clock                # Python CLI plugin (section 1)
man arch-aliases         # zsh alias module    (section 7)
man git-utils            # zsh util module     (section 7)
man kubectl-plugin       # zsh plugin module   (section 7)
apropos kubernetes       # → helm-aliases, k9s-*, kubectl-*
apropos pacman           # → arch-aliases, arch-utils, arch-plugin
apropos "QR"             # → qrcode
```

If you change a markdown source under [`.docs/`](.docs/), rebuild with:

```bash
python3 .scripts/build-man-pages.py            # incremental
python3 .scripts/build-man-pages.py --clean    # wipe and rebuild
```

## Python CLI plugins

Stand-alone tools shipped under [`.plugins/.python/`](.plugins/.python/). Each
has its own man page; click through for the markdown source.

| Command            | Description                                 | Doc                                                                                  |
| ------------------ | ------------------------------------------- | ------------------------------------------------------------------------------------ |
| `base64`           | Base64 encode/decode for text and files     | [.docs/plugins/python/base64.md](.docs/plugins/python/base64.md)                     |
| `clock`            | Terminal countdown / stopwatch / wall clock | [.docs/plugins/python/clock.md](.docs/plugins/python/clock.md)                       |
| `matrix`           | "The Matrix" rain animation                 | [.docs/plugins/python/matrix.md](.docs/plugins/python/matrix.md)                     |
| `prayer-times`     | Islamic prayer schedule via AlAdhan API     | [.docs/plugins/python/prayer-times.md](.docs/plugins/python/prayer-times.md)         |
| `qrcode`           | QR code generator via qrcode.show           | [.docs/plugins/python/qrcode.md](.docs/plugins/python/qrcode.md)                     |
| `random-quote`     | Random quote via Quotable API               | [.docs/plugins/python/random-quote.md](.docs/plugins/python/random-quote.md)         |
| `weather-forecast` | Weather + moon phases via wttr.in           | [.docs/plugins/python/weather-forecast.md](.docs/plugins/python/weather-forecast.md) |
| `web-search`       | Open browser searches across 25+ engines    | [.docs/plugins/python/web-search.md](.docs/plugins/python/web-search.md)             |

Each passes the `python-script-developer` skill validator at 100% — strict
type hints, structured logging, `argparse`, `pathlib`, specific exception
handling, and `if __name__ == "__main__": sys.exit(main())`.

## Modules inventory

Browse the per-category indexes:

- [.docs/aliases/](.docs/aliases/) — 33 alias modules
- [.docs/utils/](.docs/utils/) — 15 utility modules
- [.docs/plugins/zsh/](.docs/plugins/zsh/) — 38 zsh plugins (vendored upstream excluded)
- [.docs/plugins/python/](.docs/plugins/python/) — 8 Python CLI plugins
- [.docs/zsh-core/](.docs/zsh-core/) — 3 core config files
- [setup.md](setup.md) — bootstrap script

## Authoring with the included skills

The `.agents/skills/` directory ships two skills that this repo's own scripts
were built against:

- `linux-script-developer` — strict Bash patterns + validator (`./setup` scores 100%)
- `python-script-developer` — strict Python patterns + validator (all 8 plugins score 100%)

If you fork this repo and add new scripts, run the matching validator to keep
quality consistent:

```bash
bash    .agents/skills/linux-script-developer/scripts/validate-script.sh  ./your-script.sh
python3 .agents/skills/python-script-developer/scripts/validate-script.py ./your-script.py
```

## License

MIT — see [LICENSE](LICENSE).
