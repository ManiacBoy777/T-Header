#!/bin/bash
# ==============================================================================
# T-Header: Rename Tool
# ==============================================================================
# Safely updates the custom name in Fish shell configuration.
# ==============================================================================

set -euo pipefail

# --- Utility Functions ---
log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $1"; }

# --- Prompt for new name ---
echo
read -p "Enter new custom name for your terminal: " new_name

if [[ -z "$new_name" ]]; then
    log_error "Name cannot be empty."
    exit 1
fi

# Sanitize name (basic alphanumeric + spaces/dashes)
new_name=$(echo "$new_name" | tr -dc '[:alnum:] -')

# --- Update Fish Universal Variables ---
if command -v fish >/dev/null; then
    log_info "Updating Fish universal variables..."
    fish -c "set -Ux TNAME '$new_name'"
    fish -c "set -Ux PROC '$new_name'"
    log_success "Custom name updated to: $new_name"
else
    log_warn "Fish shell not found. Could not update variables."
fi

# --- Optional: Update old config.fish style if it exists ---
if [ -f "$HOME/.config/fish/config.fish" ]; then
    sed -i "s/TNAME=\".*\"/TNAME=\"$new_name\"/g" "$HOME/.config/fish/config.fish" 2>/dev/null || true
fi

echo "Changes will take effect in the next terminal session."
exec fish
