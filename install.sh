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

#update 2025 adds option to run original script by remo773
if [[ "$1" == "--termux" ]]; then
    echo "\"--termux\" argument passed"
    echo "Installing original script by remo773"
    echo "To remove this version follow these steps:"
    echo "bash ./T-Header/t-header.sh --remove && exit"
    read -n 1 -s -r -p "Press any key to install or press CTRL-C to cancel installation..."
    sudo_if_possible apt update
    sudo_if_possible apt upgrade -y
    sudo_if_possible apt install git -y
    git clone https://github.com/remo7777/T-Header.git $HOME/T-Header
    bash $HOME/T-Header/t-header.sh
    exit 0
else
    echo "accepted arguments: --termux"
    echo "Usage: installs the original script by remo773 made for termux instead of the desktop version"
    exit 1
fi


add_zsh_lines() {
cat >> $HOME/.zshrc <<-EOF
source $HOME/.plugins/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.plugins/zsh-autoquoter/zsh-autoquoter.zsh
ZAQ_PREFIXES=('git commit( [^ ]##)# -[^ -]#m' 'ssh( -[^ ]##)# [^ -][^ ]#')
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
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(zaq)
cols=\$(tput cols)
bash $HOME/.banner.sh \${cols} \${TNAME}
neofetch
alias python='/usr/bin/python3'

EOF
}

name_prompt() {
  echo
  echo
  echo
  read -p "Enter name: " PROC
  echo
  echo "'$PROC' will be displayed at the top of every new terminal"
  echo 
  echo "This also replaces your username in the PS1 prompt."
  echo
  echo "If you'd like to change this:"
  echo
  echo "Edit the $HOME/.zshrc file and replace the value in quotes at 'TNAME'"

}

#update & install depends
sudo_if_possible apt update -y
sudo_if_possible apt upgrade -y
sudo_if_possible apt install figlet pv binutils coreutils wget curl git zsh procps gawk neofetch python3 lolcat libncurses5-dev libncursesw5-dev ruby fzf -y
sudo_if_possible gem install lolcat
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#remove existing
#sudo_if_possible rm -rdf $HOME/T-Header

#remove conflict
sudo_if_possible rm -rdf /etc/pam.d/chsh


#git clone zsh plugins
sudo_if_possible git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.plugins/zsh-autosuggestions
sudo_if_possible git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.plugins/zsh-syntax-highlighting
sudo_if_possible git clone https://github.com/Aloxaf/fzf-tab.git $HOME/.plugins/fzf-tab
sudo_if_possible git clone https://github.com/ianthehenry/zsh-autoquoter.git $HOME/.plugins/zsh-autoquoter
#download files
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/chsh" -o /etc/pam.d/chsh
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.draw" -o $HOME/.draw
#sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.bashrc" -o $HOME/.bashrc
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/.banner.sh" -o $HOME/.banner.sh
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/rename.sh" -o /usr/bin/theader-rename
sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/master/uninstall.sh" -o /usr/bin/theader-uninstall
chmod +x /usr/bin/theader-rename
chmod +x /usr/bin/theader-uninstall

#name prompt
name_prompt
clear

#add lines to .zshrc
add_zsh_lines

echo Complete!
echo
echo "Please wait for new terminal session to start"
echo
echo "The first time might take a second"
zsh