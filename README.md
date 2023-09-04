# T-Header script
This Bash script contains Oh-My-Zsh With, command autosuggestion, syntax highlight plugins and terminal header with own name for Terminal. 
## Preview
![image](https://github.com/ManiacBoy777/T-Header/assets/29928632/c5c270b7-e13f-4f2d-9a6b-a43d982cacb8)
![image](https://github.com/ManiacBoy777/T-Header/assets/29928632/ffc1b07e-11b6-4561-b0c0-f738a472958c)

## Features

- [x] Support for oh-my-zsh themes
- [x] zsh-autosuggest-command plugin
        (Inline Command Autosuggestions)
- [x] zsh-syntax-highlighting plugin
        (Highlight Valid Commands while typing)
- [x] terminal-banner
- [x] PS1 with custom trim path indicator
- [x] Custom prompt cursor
- [x] Neofetch added to header

## Installation
> [!NOTE]
> This should be run from `root` account. This script was originally created for Termux which runs in a type of proot. This version was modified and tested in a chroot enviroment on WSL > 
> It has not been tested on a normal user account and may need futher testing to do so. This is planned for a later date.

##### 1. Run command to install
`cd && apt update -y && apt upgrade -y && apt install git -y && rm -rdf $HOME/T-Header && git clone https://github.com/ManiacBoy777/T-Header.git && bash $HOME/T-Header/install.sh`
##### 2. after complete all processing just open new terminal session or run 
`source ~/.zshrc`

## Uninstallation

type `theader-uninstall` from zsh shell or run `bash $HOME/T-Header/uninstall.sh`

## Reinstallation
> [!NOTE] If you think something went wrong during install and want to try again try `theader-reinstall`

> [!WARNING]
> This script has the potential for lots of bugs and is still being worked on. There may come a point where the script is completely rewritten to work better on desktop as it was originally written for the Android app Termux
