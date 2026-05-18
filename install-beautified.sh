#!/bin/bash
# ==============================================================================
# T-Header: Beautified Installer using Charmbracelet Tools
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

# --- Setup Gum ---
setup_gum() {
    if ! command -v gum &> /dev/null; then
        echo "Installing gum for a glamorous installation experience..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install gum -y
    fi
}

# --- Utility Functions with Gum ---
log_header() {
    gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 "T-Header Installer" "Beautified by Charmbracelet"
}

log_info() {
    gum style --foreground 4 "$1"
}

log_success() {
    gum style --foreground 2 "✔ $1"
}

log_warn() {
    gum style --foreground 3 "⚠ $1"
}

log_error() {
    gum style --foreground 1 "✘ $1"
    exit 1
}

sudo_if_needed() {
    if [[ "$EUID" -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

# --- Installation Steps ---

install_dependencies() {
    log_info "Updating and installing dependencies..."
    
    local pkgs=(
        figlet pv binutils coreutils wget curl git fish procps gawk 
        python3 python3-pip lolcat libncurses5-dev libncursesw5-dev 
        ruby fzf zoxide tmux
    )

    gum spin --spinner dot --title "Updating system packages..." -- sudo_if_needed apt update -y
    gum spin --spinner dot --title "Installing core dependencies..." -- sudo_if_needed apt install "${pkgs[@]}" -y
    
    log_info "Installing Ruby and Python gems/packages..."
    gum spin --spinner dot --title "Installing lolcat gem..." -- sudo_if_needed gem install lolcat
    gum spin --spinner dot --title "Installing terminal-widgets..." -- python3 -m pip install terminal-widgets --break-system-packages || log_warn "Failed to install terminal-widgets, skipping..."
}

setup_fish_environment() {
    log_info "Setting up Fish shell environment..."
    mkdir -p "$CONF_D_DIR" "$FUNCTIONS_DIR"
    
    # Install Oh My Fish (OMF)
    if [ ! -d "$HOME/.local/share/omf" ]; then
        log_info "Installing Oh My Fish..."
        gum spin --spinner dot --title "Downloading OMF..." -- bash -c "curl -sL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish -c 'source - --noninteractive'"
    fi
    
    # Install Fisher
    if [ ! -f "$FUNCTIONS_DIR/fisher.fish" ]; then
        log_info "Installing Fisher..."
        gum spin --spinner dot --title "Installing Fisher..." -- fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fi
    
    # Install plugins
    log_info "Installing Fish plugins..."
    gum spin --spinner dot --title "Installing bira theme..." -- fish -c 'omf install bira'
    gum spin --spinner dot --title "Installing essential plugins..." -- fish -c 'fisher install patrickf1/fzf.fish ttscoff/fuzzy_cd meaningful-ooo/sponge franciscolourenco/done'
}

download_assets() {
    log_info "Downloading assets and configuration files..."
    
    # Figlet font
    gum spin --spinner dot --title "Downloading Shadow font..." -- sudo_if_needed curl -fsSL "$BASE_URL/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
    
    local files=(
        ".draw:$HOME/.draw"
        ".banner.sh:$HOME/.banner.sh"
        "rename.sh:/usr/bin/theader-rename"
        "uninstall.sh:/usr/bin/theader-uninstall"
    )
    
    for item in "${files[@]}"; do
        local src="${item%%:*}"
        local dst="${item##*:}"
        gum spin --spinner dot --title "Downloading $src..." -- sudo_if_needed curl -fsSL "$BASE_URL/$src" -o "$dst"
        sudo_if_needed chmod +x "$dst"
    done
}

configure_fish_modular() {
    log_info "Configuring Fish shell..."
    
    # Get custom name from user using gum
    local tname
    tname=$(gum input --placeholder "Enter your custom name (default: DedSec)" --value "DedSec")
    
    cat > "$CONF_D_DIR/t-header-config.fish" <<EOF
if not status is-interactive
    exit
end

set fish_greeting ''
set -gx TNAME "$tname"

if status is-interactive
    and not set -q SSH_TTY
    and type -q twidgets

    twidgets \
        --row-gap 1 \
        --column-gap 1 \
        --column 1 \
        --row 0 \
        --direction row \
        --margin 0 \
        --no-badge
end

# Aliases
if type -q exa
    alias l 'exa'
    alias ls 'exa'
    alias la 'exa -a'
    alias ll 'exa -Fhl'
else
    alias l 'ls --color=auto'
    alias ls 'ls --color=auto'
    alias la 'ls --color=auto -a'
    alias ll 'ls --color=auto -Fhl'
end

alias cp 'cp -i'
alias mv 'mv -i'
alias rm 'rm -i'
alias cd 'z'
alias python 'python3'

# T-Header Banner
if test -f \$HOME/.banner.sh
    bash \$HOME/.banner.sh (tput cols) \$TNAME
end
EOF
}

main() {
    setup_gum
    clear
    log_header
    
    if ! gum confirm "Do you want to proceed with the T-Header installation?"; then
        log_info "Installation cancelled."
        exit 0
    fi
    
    install_dependencies
    setup_fish_environment
    download_assets
    configure_fish_modular
    
    log_success "T-Header installation complete!"
    gum style --foreground 212 --border-foreground 212 --border rounded --align center --width 50 "Restart your terminal or run 'fish' to see the changes!"
}

main
