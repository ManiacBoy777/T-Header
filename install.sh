#!/bin/bash
# Define a function that runs a command with sudo if possible and needed
sudo_if_possible() {
  # Check if sudo is available
  if command -v sudo >/dev/null 2>&1; then
    # Check if the user is not root
    if [[ "$EUID" -ne 0 ]]; then
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
#install
sudo_if_possible apt update -y
sudo_if_possible apt upgrade -y
sudo_if_possible apt install figlet pv binutils coreutils wget curl git zsh procps gawk exa neofetch python3 lolcat libncurses5-dev libncursesw5-dev ruby fzf -y
sudo_if_possible gem install lolcat
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#remove existing
sudo_if_possible rm -rdf $HOME/T-Header
sudo_if_possible rm -f /etc/pam.d/chsh


#git clone
sudo_if_possible git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.plugins/zsh-autosuggestions
sudo_if_possible git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.plugins/zsh-syntax-highlighting
sudo_if_possible git clone https://github.com/Aloxaf/fzf-tab.git $HOME/.plugins/fzf-tab
#copy files
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/chsh" -o /etc/pam.d/chsh
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.object/.draw" -o $HOME/.draw
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.object/.bashrc" -o $HOME/.bashrc
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.banner.sh" -o $HOME/.banner.sh

#name prompt

echo -n "Enter name:"; read PROC
echo
echo "'$PROC' will be displayed at the top of every new terminal"
echo 
echo "This also replaces your username in the PS1 prompt."
echo
echo "If you'd like to change this:"
echo
echo "Edit the $HOME/.zshrc file and replace the value in quotes at 'TNAME'"

#add lines to .zshrc
 
sudo_if_possible cat >> $HOME/.zshrc <<-EOF
source $HOME/.plugins/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

tput cnorm
clear
## terminal banner
#$HOME/T-Header/ASCII-Shadow.flf "$PROC" | lolcat;
echo
## cursor
printf '\e[4 q'
## prompt
TNAME="$PROC"
setopt prompt_subst

PROMPT=$'
%{\e[0;31m%}┌─[%{\e[1;34m%}%B%{\${TNAME}%}%{\e[1;33m%}@%{\e[1;36m%}$HOSTNAME%b%{\e[0;31m%}]─[%{\e[0;32m%}%(4~|/%2~|%~)%{\e[0;31m%}]%b
%{\e[0;31m%}└──╼ %{\e[1;31m%}%B❯%{\e[1;34m%}❯%{\e[1;90m%}❯%{\e[0m%}%b '

## Replace 'ls' with 'exa' (if available) + some aliases.
if [ -n "\$(command -v exa)" ]; then
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

## Safety.
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=39'
ZSH_HIGHLIGHT_STYLES[comment]=fg=226,bold
cols=\$(tput cols)
bash ~/.banner.sh \${cols} \${TNAME}
neofetch
alias theader-rename='python $HOME/T-Header/rename.py'
alias python='/usr/bin/python3'

EOF

echo Complete!
echo
echo "Please wait for new terminal session to start"
echo
echo "The first time might take a second"
zsh