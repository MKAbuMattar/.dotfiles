# debian-aliases

## NAME

**debian-aliases** — `apt`, `aptitude`, `apt-file`, and `dpkg` shortcuts for Debian-based distros.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "debian" ...)
```

## DESCRIPTION

A compact two- and three-letter scheme for everyday package management.
Read-only aliases (search, policy, list) load unconditionally. Privileged
operations are gated by an inline `(( $+commands[sudo] ))` check: if `sudo`
is available the destructive aliases use `sudo $apt_pref ...`; otherwise
they fall back to `su -lc '...' root`. Two of the su-branch wrappers
(`ai`, `ap`, `aar`, `abd`) are implemented as **functions**, not aliases,
so that user-supplied arguments are safely quoted with zsh's
`${(j: :)${(qq)@}}` parameter expansion before being passed to `su -lc`.

`$apt_pref` (e.g. `apt-get` or `apt`) and `$apt_upgr` (e.g. `upgrade` or
`dist-upgrade`) are expected to be set by the loader before this file is
sourced.

## ALIASES

### Generic search / inspection (no sudo)

| Alias  | Expansion                                                              | Description                      |
| ------ | ---------------------------------------------------------------------- | -------------------------------- |
| `age`  | `apt-get`                                                              | Shorthand for `apt-get`.         |
| `api`  | `aptitude`                                                             | Shorthand for `aptitude`.        |
| `acs`  | `apt-cache search`                                                     | Search via apt-cache.            |
| `aps`  | `aptitude search`                                                      | Search via aptitude.             |
| `as`   | `aptitude -F '* %p -> %d \n(%v/%V)' --no-gui --disable-columns search` | Verbose aptitude search.         |
| `afs`  | `apt-file search --regexp`                                             | Find which package ships a file. |
| `asrc` | `apt-get source`                                                       | Fetch source package.            |
| `app`  | `apt-cache policy`                                                     | Show install candidates.         |

### Superuser operations (with `sudo`)

`$apt_pref` is expanded at load time (e.g. `apt-get`).

| Alias    | Expansion                                                                              | Description                                      |
| -------- | -------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `aac`    | `sudo $apt_pref autoclean`                                                             | Drop obsolete archives.                          |
| `abd`    | `sudo $apt_pref build-dep`                                                             | Install build deps for a source pkg.             |
| `ac`     | `sudo $apt_pref clean`                                                                 | Wipe the local archive.                          |
| `ad`     | `sudo $apt_pref update`                                                                | Refresh package lists.                           |
| `adg`    | `sudo $apt_pref update && sudo $apt_pref $apt_upgr`                                    | Update + upgrade.                                |
| `adu`    | `sudo $apt_pref update && sudo $apt_pref dist-upgrade`                                 | Update + dist-upgrade.                           |
| `afu`    | `sudo apt-file update`                                                                 | Refresh apt-file db.                             |
| `au`     | `sudo $apt_pref $apt_upgr`                                                             | Upgrade only.                                    |
| `ai`     | `sudo $apt_pref install`                                                               | Install.                                         |
| `ail`    | `sed -e 's/  */ /g' -e 's/ *//' \| cut -s -d ' ' -f 1 \| xargs sudo $apt_pref install` | Install the first column of piped search output. |
| `ap`     | `sudo $apt_pref purge`                                                                 | Purge (config + data).                           |
| `aar`    | `sudo $apt_pref autoremove`                                                            | Remove unused deps.                              |
| `ads`    | `sudo apt-get dselect-upgrade`                                                         | Apply dselect selections.                        |
| `alu`    | `sudo apt update && apt list -u && sudo apt upgrade`                                   | Show upgradable then upgrade.                    |
| `dia`    | `sudo dpkg -i ./*.deb`                                                                 | Install every `.deb` in cwd.                     |
| `di`     | `sudo dpkg -i`                                                                         | Install a specific `.deb`.                       |
| `kclean` | `sudo aptitude remove -P "?and(~i~nlinux-(ima\|hea) ?not(~n$(uname -r)))"`             | Purge all kernel images/headers except the running one. |

### Superuser operations (su fallback)

When `sudo` is absent the same alias names wrap `su -lc '...' root`. Where
quoting matters, the implementation is a **function**:

```zsh
function ai() {
    local args="${(j: :)${(qq)@}}"     # zsh-safe quoting
    print "su -lc '$apt_pref install $args' root"
    su -lc "$apt_pref install $args" root
}
```

The same pattern is used for `abd`, `ap`, and `aar`. Simpler invocations
(`aac`, `ac`, `ad`, `adg`, `adu`, `afu`, `au`, `dia`, `di`, `kclean`) remain
plain aliases that quote literal strings. `ail` and `ads` are not defined
in the su branch.

### Miscellaneous

| Alias     | Expansion                                      | Description                   |
| --------- | ---------------------------------------------- | ----------------------------- |
| `allpkgs` | `aptitude search -F "%p" --disable-columns ~i` | List every installed package. |
| `mydeb`   | `time dpkg-buildpackage -rfakeroot -us -uc`    | Build a basic `.deb`.         |

## FUNCTIONS

### `ai`, `abd`, `ap`, `aar` (su fallback only)

Quote each positional argument with zsh's `${(qq)@}` flag, join them with
spaces via `${(j: :)…}`, echo the resulting `su -lc '…' root` command for
transparency, then execute it. This avoids word-splitting and injection
problems when filenames or package names contain spaces or shell
metacharacters.

## REQUIREMENTS

- `apt-get` / `apt`, `aptitude`, `apt-cache`, `apt-file`, `dpkg`.
- `sudo` is preferred; `su` is used as a fallback.
- The `$apt_pref` and `$apt_upgr` variables must be set before this file
  is sourced (e.g. by your loader / a setup util).

## EXAMPLES

```bash
ad && au               # Update lists and upgrade
ai htop ripgrep        # Install (safe quoting under su, too)
afs '^/usr/bin/fd$'    # Which package ships /usr/bin/fd?
kclean                 # Reclaim disk by purging old kernels
dia                    # Install every *.deb in the current dir
```

## SEE ALSO

- [.docs/plugins/zsh/debian.md](../plugins/zsh/debian.md)
- [.docs/utils/debian.md](../utils/debian.md)
- [.docs/README.md](../README.md)
