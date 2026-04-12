#!/bin/bash
# ==============================================================================
# T-Header: Safe Uninstaller
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
echo "This will remove the T-Header customization."
read -p "Are you sure you want to proceed? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_info "Uninstallation cancelled."
    exit 0
fi

# --- Removal ---
log_info "Removing T-Header components..."

# 1. Remove files in HOME
rm -f "$HOME/.draw" "$HOME/.draw.sh" "$HOME/.banner.sh"

# 2. Remove Fish configuration (modular files only)
if [ -f "$HOME/.config/fish/conf.d/t-header-config.fish" ]; then
    rm -f "$HOME/.config/fish/conf.d/t-header-config.fish"
fi

# 3. Restore fish_prompt if it was our version
if [ -f "$HOME/.config/fish/functions/fish_prompt.fish" ]; then
    if grep -q "┌─\[" "$HOME/.config/fish/functions/fish_prompt.fish"; then
        log_info "Restoring default fish_prompt..."
        rm -f "$HOME/.config/fish/functions/fish_prompt.fish"
    fi
fi

# 4. Remove system-wide binaries
sudo_if_needed rm -f /usr/bin/theader-rename /usr/bin/theader-uninstall /usr/share/figlet/ASCII-Shadow.flf

log_success "T-Header components removed."
log_info "Note: Installed packages (fish, figlet, etc.) were kept. You can remove them manually with 'apt remove' if desired."
log_info "Please restart your terminal."
