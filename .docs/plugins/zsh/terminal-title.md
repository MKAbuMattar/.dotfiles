# terminal-title-plugin

## NAME

**terminal-title-plugin** — sets the terminal window title from a
`precmd` hook with a git-aware, cached project status string.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "terminal-title" ...)
```

## DESCRIPTION

This plugin replaces the default automatic title behaviour by setting
`DISABLE_AUTO_TITLE=true` and installing its own `precmd` hook,
`set_name`. The hook updates the OSC 0/2 terminal title via
`printf '\033]0;%s\007'` immediately before each new prompt.

Unlike a traditional `PROMPT`/`RPROMPT` modifier, the work is done in
`precmd` so the title reflects the state captured just _after_ the
previous command finished, and so the heavier git probing does not
slow down each redraw of the prompt.

The hook produces:

- Outside any git repository: `<folder-icon> <basename of $PWD>`.
- Inside a git repository: `<repo-icon> <repo-name> (<git-icon> <branch>)`
  plus optional badges:
  - `[+ins -del]` when there are unstaged changes and
    `TITLE_SHOW_METRICS` is non-zero;
  - a staged-files glyph when files are staged;
  - an untracked-files glyph when there are untracked files;
  - `⇡N`/`⇣N` ahead/behind counters relative to upstream;
  - `≡N` stash count when `TITLE_SHOW_STASH` is non-zero and
    `.git/logs/refs/stash` exists.

A dynamic cache key composed of `$PWD`, `HEAD`, the index `mtime`, and
a single-line dirty probe (`git ls-files -m --others --exclude-standard
| head -n 1`) is used to skip the full `git status` parse when nothing
relevant has changed.

## EFFECTS

- Sets `DISABLE_AUTO_TITLE=true` so other plugins do not also rewrite
  the title.
- Initializes feature flags `TITLE_SHOW_METRICS` and `TITLE_SHOW_STASH`
  to `1` when unset.
- Declares the global cache variables `__TITLE_CACHE` and
  `__TITLE_CACHE_KEY`.
- Defines icon variables `ICON_GIT`, `ICON_REPO`, `ICON_FOLDER`,
  `ICON_STAGED`, `ICON_UNTRACKED` (Nerd Font glyphs).
- Loads the `zsh/stat` module (silently tolerating absence).
- Defines `_set_term_title` and `set_name`.
- Registers `set_name` via `add-zsh-hook precmd`.

## FUNCTIONS

- `_set_term_title <text>` — low-level helper that emits the OSC
  escape sequence to set the terminal title.
- `set_name` — the `precmd` hook. Detects whether the current
  directory is a git working tree, builds a status string, and writes
  it to the title, using `__TITLE_CACHE` / `__TITLE_CACHE_KEY` to
  avoid repeated work.

## ENVIRONMENT

- `DISABLE_AUTO_TITLE` — set to `true` by this plugin to disable any
  other automatic title-setting in the shell.
- `TITLE_SHOW_METRICS` — set to `0` to suppress the `[+ins -del]`
  block. Defaults to `1`.
- `TITLE_SHOW_STASH` — set to `0` to suppress the stash counter.
  Defaults to `1`.
- `__TITLE_CACHE`, `__TITLE_CACHE_KEY` — internal, do not set
  manually.

## FILES

- `$git_dir/HEAD`, `$git_dir/index`, `$git_dir/logs/refs/stash` —
  inspected by the cache key and stash counter.
- `.plugins/.zsh/terminal-title/terminal-title.plugin.zsh` — the
  plugin source.

## REQUIREMENTS

- `git` on PATH for the in-repo title (the bare-folder title works
  without it).
- A terminal emulator that respects OSC 0/2 title escapes (kitty,
  alacritty, gnome-terminal, foot, xterm, etc.).
- The `zsh/stat` zmodload for index `mtime` (loaded best-effort).
- Nerd Font glyphs in your terminal for the icons.

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/README.md](../../README.md)
