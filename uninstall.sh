#!/bin/bash
# ==============================================================================
# T-Header: Safe Uninstaller (Zsh Version)
# ==============================================================================
# Removes only the components installed by T-Header, preserving user data.
# ==============================================================================

set -euo pipefail

# --- Utility Functions ---
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $1"; }

sudo_if_needed() {
    if [[ "$EUID" -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

# --- Confirmation ---
echo "This will remove the T-Header customization (Zsh version)."
read -p "Are you sure you want to proceed? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_info "Uninstallation cancelled."
    exit 0
fi

# --- Removal ---
log_info "Removing T-Header Zsh components..."

# 1. Remove files in HOME
rm -f "$HOME/.draw" "$HOME/.draw.sh" "$HOME/.banner.sh" "$HOME/.zshrc_t_header"

# 2. Clean .zshrc
if [ -f "$HOME/.zshrc" ]; then
    log_info "Cleaning .zshrc..."
    sed -i '/# T-Header Integration/,/source \$HOME\/.zshrc_t_header/d' "$HOME/.zshrc"
fi

# 3. Remove plugins directory
if [ -d "$HOME/.zsh_plugins" ]; then
    log_info "Removing Zsh plugins..."
    rm -rf "$HOME/.zsh_plugins"
fi

# 4. Remove system-wide binaries
sudo_if_needed rm -f /usr/bin/theader-rename /usr/bin/theader-uninstall /usr/share/figlet/ASCII-Shadow.flf

log_success "T-Header Zsh components removed."
log_info "Note: Oh My Zsh and installed packages were kept. You can remove them manually if desired."
log_info "Please restart your terminal."
