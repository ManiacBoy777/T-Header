#!/bin/bash
# Define a function that runs a command with sudo if possible and needed
sudo_if_possible() {
  # Check if sudo is available
  if command -v sudo >/dev/null 2>&1; then
    # Check if the user is not root
    if [ "$EUID" -ne 0 ]; then
      # Run the command with sudo
      sudo "$@"
    else
      # Run the command without sudo
      "$@"
    fi
  else
    # Run the command without sudo
    "$@"
  fi
}

sudo_if_possible rm -rdf $HOME/.draw
sudo_if_possible rm -rdf $HOME/.bashrc
sudo_if_possible rm -rdf $HOME/.banner.sh
sudo_if_possible bash -c $HOME/. oh-my-zsh/tools/uninstall.sh