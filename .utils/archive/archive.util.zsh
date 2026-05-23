#!/usr/bin/env zsh

# Functions #################################################################

# Universal archive extractor: dispatches on file extension.
# Usage: extract <file> [<file>...]
function extract() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: extract <archive> [<archive>...]"
        return 1
    fi
    local file
    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            echo "✗ $file: not a regular file"
            continue
        fi
        echo "→ extracting $file"
        case "$file" in
            *.tar.bz2|*.tbz2)        tar xjf  "$file" ;;
            *.tar.gz|*.tgz)          tar xzf  "$file" ;;
            *.tar.xz|*.txz)          tar xJf  "$file" ;;
            *.tar.zst|*.tzst)        tar --zstd -xf "$file" ;;
            *.tar.lz4)               tar --lz4 -xf  "$file" ;;
            *.tar)                   tar xf   "$file" ;;
            *.bz2)                   bunzip2  "$file" ;;
            *.gz)                    gunzip   "$file" ;;
            *.xz)                    unxz     "$file" ;;
            *.zst)                   unzstd   "$file" ;;
            *.lz4)                   lz4 -d   "$file" ;;
            *.zip|*.jar|*.war)       unzip    "$file" ;;
            *.7z)                    7z x     "$file" ;;
            *.rar)                   unrar x  "$file" ;;
            *.Z)                     uncompress "$file" ;;
            *.deb)                   ar x     "$file" ;;
            *.rpm)                   (( $+commands[rpm2cpio] )) \
                                       && rpm2cpio "$file" | cpio -idmv \
                                       || echo "rpm2cpio required" ;;
            *)
                echo "✗ $file: unknown archive type"
                ;;
        esac
    done
}

# Universal compressor — picks the best available algorithm.
# Usage: compress <archive-name> <path> [<path>...]
# Format is inferred from the target extension. If no extension, uses .tar.zst
# when zstd is installed, else .tar.xz.
function compress() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: compress <output.archive> <path> [<path>...]"
        echo "  Inferred from extension: .tar.gz .tar.bz2 .tar.xz .tar.zst .zip"
        return 1
    fi
    local out="$1"; shift
    case "$out" in
        *.tar.gz|*.tgz)          tar czf  "$out" "$@" ;;
        *.tar.bz2|*.tbz2)        tar cjf  "$out" "$@" ;;
        *.tar.xz|*.txz)          tar cJf  "$out" "$@" ;;
        *.tar.zst|*.tzst)        tar --zstd -cf "$out" "$@" ;;
        *.tar)                   tar cf   "$out" "$@" ;;
        *.zip)                   zip -r   "$out" "$@" ;;
        *.7z)                    7z a     "$out" "$@" ;;
        *)
            local default_ext
            if (( $+commands[zstd] )); then default_ext='.tar.zst'; else default_ext='.tar.xz'; fi
            echo "Unknown extension; defaulting to ${out}${default_ext}"
            compress "${out}${default_ext}" "$@"
            ;;
    esac
}

# Show the contents of any supported archive without extracting
function archive-ls() {
    if [[ -z "$1" ]]; then
        echo "Usage: archive-ls <archive>"
        return 1
    fi
    case "$1" in
        *.tar*)            tar tf "$1" ;;
        *.zip|*.jar|*.war) unzip -l "$1" ;;
        *.7z)              7z l "$1" ;;
        *.rar)             unrar l "$1" ;;
        *) echo "Unsupported archive type for listing: $1" ;;
    esac
}
