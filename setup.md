# setup

## Description

Bootstraps the dotfiles repository into the user's environment by creating
symbolic links from this repository into `~/.config/.dotfiles` and `~/.config/`,
linking `.zshrc` into `$HOME`, ensuring the ZSH history directory exists, and
wiring an `[include]` section into `~/.gitconfig` that references every modular
`*.gitconfig` file shipped in `.config/gitconfig/`.

Run it once after cloning the repository. It is idempotent — re-running detects
existing symlinks pointing at the correct target, skips them, and prompts
before overwriting anything that points elsewhere or isn't a symlink.

## Synopsis

```
setup [OPTIONS]
```

## Options

| Option         | Type | Required | Default | Description                |
| -------------- | ---- | -------- | ------- | -------------------------- |
| `-h`, `--help` | flag | No       | —       | Show help message and exit |

The script takes no positional arguments.

## Supported Platforms

| Platform              | Supported | Notes                                     |
| --------------------- | --------- | ----------------------------------------- |
| Linux (Ubuntu/Debian) | Yes       | Bash 4.0+, requires `zsh` and `git`       |
| Linux (RHEL/Fedora)   | Yes       | Bash 4.0+, requires `zsh` and `git`       |
| macOS                 | Yes       | Bash 3.2+ (system) or Bash 5 via Homebrew |
| Windows (WSL)         | Yes       | WSL 1 or WSL 2 with `zsh` available       |
| Windows (Git Bash)    | Partial   | Symlink creation requires Developer Mode  |
| Windows (MSYS2)       | Partial   | Same caveat as Git Bash                   |

## Prerequisites

- Bash 4.0 or later
- `git` (checked at runtime; missing tools are reported as warnings)
- `zsh` (checked at runtime; missing tools are reported as warnings)
- Write access to `$HOME`, `$HOME/.config`, and `$HOME/.gitconfig`

## Examples

### First-time setup

```bash
# Linux / macOS
./setup

# Windows (Git Bash / WSL)
bash setup
```

### Re-running after a `git pull`

```bash
# Safe to re-run; existing correct symlinks are detected and skipped.
./setup
```

### Viewing help

```bash
./setup --help
```

## Output

Prints a colorized progress report to stdout describing each symlink created,
skipped, or replaced, the gitconfig include section result, and a tool-check
summary. ANSI colors are emitted only when stdout is a TTY.

Side effects:

- Creates `~/.config/.dotfiles` — either as a single symlink to the repository
  root (when `~/.config/.dotfiles` does not yet exist) or as a directory
  populated with per-subdirectory symlinks (`.plugins`, `.utils`, `.zsh`,
  `.aliases`, `.zshrc`) when it already exists.
- Symlinks each entry in the repository's `.config/` directory into
  `~/.config/<name>`.
- Symlinks `~/.config/.dotfiles/.zshrc` to `~/.zshrc`.
- Creates `~/.zsh/` if missing (used as the ZSH history directory).
- Adds or creates `~/.gitconfig` with an `[include]` block referencing every
  non-user `*.gitconfig` file under `.config/gitconfig/`.
- Builds the man pages from `.docs/` into `.man/man{1,7}/` (via
  `.scripts/build-man-pages.py`, if `python3` is available) and refreshes the
  `apropos` index with `mandb -q -u`. After this, `man <module>` and
  `apropos <keyword>` find every dotfiles page.
- Backs up any pre-existing non-symlink targets to `<target>.backup.YYYYMMDD_HHMMSS`
  after interactive confirmation.

### Exit Codes

| Code | Meaning                                     |
| ---- | ------------------------------------------- |
| 0    | Success (including skipped-by-user prompts) |
| 1    | Invalid CLI option passed                   |

## See Also

- `~/.zshrc` — the entry point sourced by zsh, links to this repo's `.zshrc`
- `.config/gitconfig/` — modular git configuration files included by `setup_gitconfig`
- `.agents/skills/linux-script-developer/SKILL.md` — the standard this script is built against
