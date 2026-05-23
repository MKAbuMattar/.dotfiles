# ==========================
# PATH Configuration
# ==========================
if [ -d "$HOME/.local/bin" ]; then
    export PATH=$HOME/.local/bin:$PATH
fi

# Initialize Homebrew if it exists (handles both Linux and macOS locations)
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ==========================
# ZSH Configuration
# ==========================
# Source modular configuration files
DOTFILES_ZSH="$HOME/.config/.dotfiles/.zsh"

[[ -f "$DOTFILES_ZSH/options.zsh" ]] && source "$DOTFILES_ZSH/options.zsh"
[[ -f "$DOTFILES_ZSH/completion.zsh" ]] && source "$DOTFILES_ZSH/completion.zsh"
[[ -f "$DOTFILES_ZSH/keybindings.zsh" ]] && source "$DOTFILES_ZSH/keybindings.zsh"

# ==========================
# Utils Configuration
# ==========================
# Source the utils system
source "$HOME/.config/.dotfiles/.utils/.utils"

# Define your utils here
UTILS=(
    # "alpine"
    # "arch"
    # "archive"
    "clipboard"
    # "debian"
    "fedora"
    # "network"
    # "opensuse"
    # "systemd"
    # "tmux"
    "git"
    # "mvn"
    "node"
    "npm"
    "pip"
    # "poetry"
    "pyenv"
    "python"
    # "redis"
    # "rust"
    # "screen"
    # "terraform"
)

# Load all enabled utils
load_utils "${UTILS[@]}"

# ==========================
# Plugin Configuration
# ==========================
# Source the plugin system
source "$HOME/.config/.dotfiles/.plugins/.plugins"

# Define your plugins here
PLUGINS=(
    # ZSH Plugins:
    "1password"
    # "alpine"
    # "ansible"
    # "arch"
    # "archive"
    # "argocd"
    "aws"
    # "azure"
    # "bat"
    # "bun"
    "copybuffer"
    # "debian"
    # "deno"
    "docker"
    # "doctl"
    # "dotnet"
    # "fd"
    # "flutter"
    # "fluxcd"
    "fedora"
    # "krew"
    # "kubectl-fzf"
    # "kubectx"
    # "opensuse"
    # "ripgrep"
    # "systemd"
    # "tmux"
    # "zoxide"
    "fzf"
    # "gcp"
    "gh"
    "git"
    # "gradle"
    # "helm"
    # "huaweicloud"
    # "k9s"
    # "kubectl"
    # "mvn"
    "npm"
    "pip"
    "pipenv"
    "pnpm"
    # "poetry"
    "pyenv"
    "python"
    "uv"
    "vscode"
    "terraform"
    # "redis"
    # "rust"
    # "screen"
    "terminal-title"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-history-substring-search"

    # Python Plugins:
    "qrcode"
    "base64"
    "clock"
    "emoji"
    "hasher"
    "httpserve"
    "matrix"
    "password-gen"
    "port-check"
    "prayer-times"
    "random-quote"
    "uuid"
    "weather-forecast"
    "web-search"
    "whois-info"
)

# Load all enabled plugins
load_plugins "${PLUGINS[@]}"

# ==========================
# Aliases Configuration
# ==========================
# Source the aliases system
source "$HOME/.config/.dotfiles/.aliases/.aliases"

# Define your aliases here
ALIASES=(
    # "alpine"
    # "ansible"
    # "arch"
    # "archive"
    # "azure"
    # "bat"
    # "conda"
    # "debian"
    # "deno"
    "docker"
    # "dotnet"
    "exa"
    # "fd"
    "fedora"
    # "kubectx"
    # "network"
    # "opensuse"
    # "ripgrep"
    # "systemd"
    # "tmux"
    # "zoxide"
    "files"
    # "flutter"
    "general"
    "git"
    # "gradle"
    # "helm"
    # "huaweicloud"
    # "k9s"
    # "kubectl"
    # "mvn"
    "npm"
    "pip"
    "pipenv"
    "pnpm"
    # "poetry"
    "pyenv"
    "python"
    "uv"
    "vscode"
    "terraform"
    # "redis"
    # "rust"
    # "screen"
)

# Load all enabled aliases
load_aliases "${ALIASES[@]}"

# ==========================
# Prompt Configuration
# ==========================
# Initialize Starship prompt
eval "$(starship init zsh)"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
