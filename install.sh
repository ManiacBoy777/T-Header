#!/bin/bash
# ==============================================================================
# T-Header: Robust Standalone Installer for Zsh Shell
# ==============================================================================
# This script is designed for remote execution:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/zsh-master/install.sh)"
# ==============================================================================

set -euo pipefail

# --- Configuration and Constants ---
REPO_OWNER="ManiacBoy777"
REPO_NAME="T-Header"
BRANCH="zsh-master"
BASE_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$HOME/.zsh_plugins"

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
        figlet pv binutils coreutils wget curl git zsh procps gawk 
        python3 python3-pip lolcat libncurses5-dev libncursesw5-dev 
        ruby fzf tmux
    )
    sudo_if_needed apt install "${pkgs[@]}" -y
    
    log_info "Installing Ruby and Python gems/packages..."
    sudo_if_needed gem install lolcat
    python3 -m pip install terminal-widgets --break-system-packages || log_warn "Failed to install terminal-widgets, skipping..."
}

setup_zsh_environment() {
    log_info "Setting up Zsh environment..."
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Setup plugins directory
    mkdir -p "$PLUGINS_DIR"
    
    local plugins=(
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "Aloxaf/fzf-tab"
        "ianthehenry/zsh-autoquoter"
    )
    
    for plugin in "${plugins[@]}"; do
        local name="${plugin##*/}"
        if [ ! -d "$PLUGINS_DIR/$name" ]; then
            log_info "Installing plugin: $name..."
            git clone "https://github.com/$plugin.git" "$PLUGINS_DIR/$name"
        fi
    done
}

download_assets() {
    log_info "Downloading assets and configuration files from GitHub..."
    
    sudo_if_needed curl -fsSL "$BASE_URL/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
    
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

configure_zsh_modular() {
    log_info "Configuring Zsh shell..."
    
    # Create a custom zsh configuration file
    cat > "$HOME/.zshrc_t_header" <<EOF
# T-Header: Zsh Configuration

# --- Plugins ---
source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh
source $PLUGINS_DIR/zsh-autoquoter/zsh-autoquoter.zsh

# --- Banner & Widgets ---
if [ -f "\$HOME/.banner.sh" ]; then
    bash "\$HOME/.banner.sh" "\$(tput cols)" "\$TNAME"
fi

if command -v python3 >/dev/null; then
    python3 -m twidgets 2>/dev/null
fi

# --- Aliases ---
if command -v exa >/dev/null; then
    alias l='exa'
    alias ls='exa'
    alias l.='exa -d .*'
    alias la='exa -a'
    alias ll='exa -Fhl'
    alias ll.='exa -Fhl -d .*'
else
    alias l='ls --color=auto'
    alias ls='ls --color=auto'
    alias l.='ls --color=auto -d .*'
    alias la='ls --color=auto -a'
    alias ll='ls --color=auto -Fhl'
    alias ll.='ls --color=auto -Fhl -d .*'
fi

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'
alias python='/usr/bin/python3'

# --- Prompt ---
# Multi-line prompt matching the Fish version
PROMPT='
%F{red}┌─[%F{blue}\$TNAME%F{yellow}@%F{cyan}%m%F{red}]─[%F{green}%~%F{red}]
%F{red}└──╼ %F{red}%B❯%F{blue}❯%F{black}❯ %f%b'

# --- Cursor ---
printf '\e[4 q'

# --- Tmux ---
if [ -z "\$TMUX" ] && command -v tmux >/dev/null; then
    exec tmux
fi
EOF

    # Ensure .zshrc sources our custom config
    if ! grep -q "source \$HOME/.zshrc_t_header" "$HOME/.zshrc"; then
        echo -e "\n# T-Header Integration\nexport TNAME=\"\$PROC\"\nsource \$HOME/.zshrc_t_header" >> "$HOME/.zshrc"
    fi
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
    
    name=$(echo "$name" | tr -dc '[:alnum:] -')
    export PROC="$name"
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

log_info "Starting T-Header robust Zsh standalone installation..."

install_dependencies
setup_zsh_environment
download_assets
name_prompt
configure_zsh_modular

log_info "Setting Zsh as default shell (if possible)..."
if command -v chsh >/dev/null; then
    sudo_if_needed chsh -s "$(which zsh)" "$(whoami)" || log_warn "Could not change default shell."
fi

log_success "T-Header Zsh installation complete!"
echo -e "\nRestart your terminal to enjoy your new setup.\n"

trap - EXIT
exec zsh
