#!/bin/bash
# ==============================================================================
# T-Header: Standalone Installer for Fish Shell
# ==============================================================================
# This script is designed for remote execution:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/install.sh)"
# ==============================================================================

set -euo pipefail

# --- Configuration and Constants ---
REPO_OWNER="ManiacBoy777"
REPO_NAME="T-Header"
BRANCH="fish-master"
BASE_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH"
CONFIG_DIR="$HOME/.config/fish"
CONF_D_DIR="$CONFIG_DIR/conf.d"
FUNCTIONS_DIR="$CONFIG_DIR/functions"

# --- Utility Functions ---

log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $1"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1; }

sudo_if_needed() {
    if [[ "$EUID" -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log_warn "An error occurred during installation. Please check the logs."
    fi
}
trap cleanup EXIT

# --- Installation Steps ---

install_dependencies() {
    log_info "Updating and installing dependencies..."
    sudo_if_needed apt update -y
    
    local pkgs=(
        figlet pv binutils coreutils wget curl git fish procps gawk 
        python3 python3-pip lolcat libncurses5-dev libncursesw5-dev 
        ruby fzf zoxide tmux
    )
    sudo_if_needed apt install "${pkgs[@]}" -y
    
    log_info "Installing Ruby and Python gems/packages..."
    sudo_if_needed gem install lolcat
    python3 -m pip install terminal-widgets --break-system-packages || log_warn "Failed to install terminal-widgets, skipping..."
}

setup_fish_environment() {
    log_info "Setting up Fish shell environment..."
    mkdir -p "$CONF_D_DIR" "$FUNCTIONS_DIR"
    
    # Install Oh My Fish (OMF)
    if [ ! -d "$HOME/.local/share/omf" ]; then
        log_info "Installing Oh My Fish..."
        curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish -c 'source - --noninteractive'
    fi
    
    # Install Fisher
    if [ ! -f "$FUNCTIONS_DIR/fisher.fish" ]; then
        log_info "Installing Fisher..."
        fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fi
    
    # Install plugins
    log_info "Installing Fish plugins..."
    fish -c 'omf install bira'
    fish -c 'fisher install patrickf1/fzf.fish ttscoff/fuzzy_cd meaningful-ooo/sponge franciscolourenco/done'
}

download_assets() {
    log_info "Downloading assets and configuration files from GitHub..."
    
    # Figlet font
    sudo_if_needed curl -fsSL "$BASE_URL/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
    
    # Files to download and their destinations
    # format: "src_file:dest_path"
    local files=(
        ".draw:$HOME/.draw"
        ".banner.sh:$HOME/.banner.sh"
        "rename.sh:/usr/bin/theader-rename"
        "uninstall.sh:/usr/bin/theader-uninstall"
    )
    
    for item in "${files[@]}"; do
        local src="${item%%:*}"
        local dst="${item##*:}"
        log_info "Downloading $src to $dst..."
        sudo_if_needed curl -fsSL "$BASE_URL/$src" -o "$dst"
        sudo_if_needed chmod +x "$dst"
    done
}

configure_fish_modular() {
    log_info "Configuring Fish shell (modular approach)..."
    
    # 1. Main configuration (aliases, env vars)
    cat > "$CONF_D_DIR/t-header-config.fish" <<EOF
# T-Header: Main Configuration
set -g fish_greeting ''

# Tmux auto-start
if not set -q TMUX
    if command -v tmux >/dev/null
        exec tmux
    end
end

# Custom Name
if not set -q TNAME
    set -Ux TNAME "\$PROC"
end

# Banner
if test -f \$HOME/.banner.sh
    bash \$HOME/.banner.sh (tput cols) \$TNAME
end

# Widgets
if command -v python3 >/dev/null
    python3 -m twidgets 2>/dev/null
end

# Aliases
if type -q exa
    alias l 'exa'
    alias ls 'exa'
    alias l. 'exa -d .*'
    alias la 'exa -a'
    alias ll 'exa -Fhl'
    alias ll. 'exa -Fhl -d .*'
else
    alias l 'ls --color=auto'
    alias ls 'ls --color=auto'
    alias l. 'ls --color=auto -d .*'
    alias la 'ls --color=auto -a'
    alias ll 'ls --color=auto -Fhl'
    alias ll. 'ls --color=auto -Fhl -d .*'
end

# Safety aliases
alias cp 'cp -i'
alias ln 'ln -i'
alias mv 'mv -i'
alias rm 'rm -i'
alias cd 'z'
alias python '/usr/bin/python3'

# Cursor style
echo -ne "\e[4 q"

# Zoxide
if type -q zoxide
    zoxide init fish | source
end
EOF

    # 2. Custom Prompt
    cat > "$FUNCTIONS_DIR/fish_prompt.fish" <<'EOF'
function fish_prompt
    set_color red
    echo -n "┌─["
    set_color blue
    echo -n $TNAME
    set_color yellow
    echo -n "@"
    set_color cyan
    echo -n (hostname)
    set_color red
    echo -n "]─["
    set_color green
    echo -n (prompt_pwd)
    set_color red
    echo "]"
    echo -n "└──╼ "
    set_color red --bold
    echo -n "❯"
    set_color blue
    echo -n "❯"
    set_color brblack
    echo -n "❯ "
    set_color normal
end
EOF
}

name_prompt() {
    echo
    local name=""
    while [[ -z "$name" ]]; do
        read -p "Enter your custom name for the terminal: " name
        if [[ -z "$name" ]]; then
            log_warn "Name cannot be empty. Please try again."
        fi
    done
    
    # Sanitize name
    name=$(echo "$name" | tr -dc '[:alnum:] -')
    
    export PROC="$name"
    fish -c "set -Ux TNAME '$name'"
    fish -c "set -Ux PROC '$name'"
}

# --- Main Execution ---

if [[ "${1:-}" == "--termux" ]]; then
    log_info "Installing Termux-compatible version (original by remo773)..."
    sudo_if_needed apt update && sudo_if_needed apt upgrade -y
    sudo_if_needed apt install git -y
    git clone https://github.com/remo7777/T-Header.git "$HOME/T-Header-termux"
    bash "$HOME/T-Header-termux/t-header.sh"
    exit 0
fi

# Desktop/Standard Installation
log_info "Starting T-Header standalone installation..."

install_dependencies
setup_fish_environment
download_assets
name_prompt
configure_fish_modular

# Finalize
log_info "Setting Fish as default shell (if possible)..."
if command -v chsh >/dev/null; then
    sudo_if_needed chsh -s "$(which fish)" "$(whoami)" || log_warn "Could not change default shell. Please run: chsh -s \$(which fish)"
fi

log_success "T-Header installation complete!"
echo -e "\nRestart your terminal to enjoy your new setup.\n"

# Prevent exit trap from firing log_error
trap - EXIT
exec fish
