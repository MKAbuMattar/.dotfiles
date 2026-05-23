# files-aliases

## NAME

**files-aliases** — quick directory-traversal shortcuts.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "files" ...)
```

## DESCRIPTION

Two flavours of "jump up N parent directories":

- Numbered: `cd.1` … `cd.5`.
- Dot-chain: `.`, `..`, `...`, `....`, `.....`.

The dot-chain form **overrides the shell builtin `.`** (source). After this
module loads, typing `.` on its own will `cd ..` rather than source a file.
Use the full `source` keyword (or `builtin .`) to source scripts.

## ALIASES

### Numbered jumps

| Alias  | Expansion           | Description |
| ------ | ------------------- | ----------- |
| `cd.1` | `cd ..`             | Up one.     |
| `cd.2` | `cd ../..`          | Up two.     |
| `cd.3` | `cd ../../..`       | Up three.   |
| `cd.4` | `cd ../../../..`    | Up four.    |
| `cd.5` | `cd ../../../../..` | Up five.    |

### Dot-chain jumps

| Alias   | Expansion           | Description                                |
| ------- | ------------------- | ------------------------------------------ |
| `.`     | `cd ..`             | Up one — **shadows the `source` builtin**. |
| `..`    | `cd ../..`          | Up two.                                    |
| `...`   | `cd ../../..`       | Up three.                                  |
| `....`  | `cd ../../../..`    | Up four.                                   |
| `.....` | `cd ../../../../..` | Up five.                                   |

## REQUIREMENTS

- None — pure zsh builtins.

## EXAMPLES

```bash
...               # cd ../../..
cd.4              # cd ../../../..
source ./env.sh   # use `source`, not `.`, because of the override
```

## SEE ALSO

- [.docs/README.md](../README.md)
