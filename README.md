# T-Header script
This Bash script contains Oh-My-Fish With, command autosuggestion, syntax highlighting and terminal header with own name for Terminal. 
## Preview
![image](https://github.com/ManiacBoy777/T-Header/assets/29928632/c5c270b7-e13f-4f2d-9a6b-a43d982cacb8)
![image](https://github.com/ManiacBoy777/T-Header/assets/29928632/ffc1b07e-11b6-4561-b0c0-f738a472958c)

## Features

- [x] Support themes
- [x] Built-in autosuggestions
        (Inline Command Autosuggestions)
- [x] Built-in syntax-highlighting
        (Highlight Valid Commands while typing)
- [x] fzf-tab plugin
        (Better TAB)
- [x] Custom terminal-banner
- [x] Custom PS1 with custom trim path indicator
- [x] Custom prompt cursor
- [x] Neofetch added to header
- [x] Works as sudoer or root!
- [x] Adds tmux to manage sessions (i.e. prevents accidental ssh disconnection terminating jobs)

## Installation
##### Run command to install
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/install.sh)"
```
##### (Optional, for termux users only)
This will install the original script by remo773
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/zsh-master/install.sh)" --termux
```

## Uninstallation

type
```
theader-uninstall
```
from fish shell or run 
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/uninstall.sh)"
```