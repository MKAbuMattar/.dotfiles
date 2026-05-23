#!/usr/bin/env zsh

# Do nothing if ansible is not installed
(( ${+commands[ansible]} )) || return

# ==========================
# Ansible Functions
# ==========================

function ansible-version(){
    ansible --version
}

function ansible-role-init(){
    if ! [ -z $1 ] ; then
        echo "Ansible Role : $1 Creating...."
        ansible-galaxy init $1
        tree $1
    else
        echo "Usage : ansible-role-init <role name>"
        echo "Example : ansible-role-init role1"
    fi
}

# ==========================
# Ansible Completion
# ==========================

# Set cache directory
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Generate ansible completions if not exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_ansible" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_ansible" -mtime +7 2>/dev/null)" ]]; then
    # Create basic ansible completion
    cat > "$ZSH_CACHE_DIR/completions/_ansible" << 'EOF'
#compdef ansible ansible-playbook ansible-vault ansible-galaxy ansible-config ansible-console ansible-doc ansible-inventory ansible-pull

case "$service" in
  ansible)
    _arguments \
      '(-h --help)'{-h,--help}'[show help message]' \
      '(-v --version)'{-v,--version}'[show version]' \
      '*:host:_hosts'
    ;;
  ansible-playbook)
    _arguments \
      '(-h --help)'{-h,--help}'[show help message]' \
      '(-i --inventory)'{-i,--inventory}'[inventory file]:file:_files' \
      '*:playbook:_files -g "*.yml"'
    ;;
  ansible-vault)
    _arguments \
      '(-h --help)'{-h,--help}'[show help message]' \
      '1:command:(create decrypt edit encrypt encrypt_string rekey view)'
    ;;
  ansible-galaxy)
    _arguments \
      '(-h --help)'{-h,--help}'[show help message]' \
      '1:command:(init install list remove search)'
    ;;
  *)
    _arguments '(-h --help)'{-h,--help}'[show help message]'
    ;;
esac
EOF
fi
