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
elif [[ -z "$1"  ]]; then

    add_fish_lines() {
cat > $HOME/.config/fish/config.fish <<-EOF
# ~/.config/fish/config.fish
set fish_greeting ''
# --- Name Banner ---
if not set -q TNAME
    set -Ux TNAME "$PROC"   # replace with your custom name
end

# Show banner (Fish runs scripts differently; this uses your existing banner.sh if available)
if test -f $HOME/.banner.sh
    set cols (tput cols)
    bash $HOME/.banner.sh \$cols \$TNAME 
end

# terminal-widgets at startup
python -m twidgets

# --- Aliases ---
if type -q exa
    alias l 'exa'
    alias ls 'exa'
    alias l. 'exa -d .*'
    alias la 'exa -a'
    alias ll 'exa -Fhl'
    alias ll. 'exa -Fhl -d .*'
else
    alias l 'ls --color=auto'
    alias ls 'ls --color=auto'
    alias l. 'ls --color=auto -d .*'
    alias la 'ls --color=auto -a'
    alias ll 'ls --color=auto -Fhl'
    alias ll. 'ls --color=auto -Fhl -d .*'
end

# Safety aliases
alias cp 'cp -i'
alias ln 'ln -i'
alias mv 'mv -i'
alias rm 'rm -i'
alias cd 'z'
# Force python -> python3
alias python '/usr/bin/python3'

# --- Cursor style ---
# Makes cursor a blinking underline
echo -ne "\e[4 q"

   zoxide init fish | source

#tmux
# Only start tmux if not already inside tmux
if not set -q TMUX
    tmux
end

EOF
}

    add_custom_prompt_lines() {
cat >> $HOME/.config/fish/functions/fish_prompt.fish <<-'EOF'
# ~/.config/fish/functions/fish_prompt.fish
function fish_prompt
    set_color red
    echo -n "┌─["

    set_color blue
    echo -n $TNAME

    set_color yellow
    echo -n "@"

    set_color cyan
    echo -n (hostname)

    set_color red
    echo -n "]─["

    set_color green
    echo -n (prompt_pwd)

    set_color red
    echo "]"

    echo -n "└──╼ "

    set_color red --bold
    echo -n "❯"

    set_color blue
    echo -n "❯"

    set_color brblack
    echo -n "❯ "

    set_color normal
end

EOF
}





    
    name_prompt() {
  echo
  echo
  echo
  read -p 'Enter name: ' PROC
  fish -c "set -Ux TNAME '$PROC'"
  fish -c "set -Ux PROC '$TNAME'"
  echo
  echo "$PROC will be displayed at the top of every new terminal"
  echo 
  echo "This also replaces your username in the PS1 prompt."
  echo
  echo "If you'd like to change this:"
  echo
  echo "Edit the $HOME/.config/fish/fish.config file and replace the value in quotes at 'TNAME'"
  sleep 5

}
    
    #update & install depends
    sudo_if_possible apt update -y
    sudo_if_possible apt upgrade -y
    sudo_if_possible apt install figlet pv binutils coreutils wget curl git fish procps gawk python3 python3-pip lolcat libncurses5-dev libncursesw5-dev ruby fzf zoxide tmux -y
    sudo_if_possible gem install lolcat
    python3 -m pip install terminal-widgets --break-system-packages
    fish -c "set -Ux SHELL 'fish' "
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish -c 'source - --noninteractive'    
    #remove existing
    #sudo_if_possible rm -rdf $HOME/T-Header

    #remove conflict
    sudo_if_possible rm -rdf /etc/pam.d/chsh


    # Install plugins & Theme
    fish -c 'omf install bira'
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fish -c 'fisher install patrickf1/fzf.fish'
    fish -c 'fisher install ttscoff/fuzzy_cd'
    fish -c 'fisher install meaningful-ooo/sponge'
    fish -c 'fisher install franciscolourenco/done'
    # Download files
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/ASCII-Shadow.flf" -o /usr/share/figlet/ASCII-Shadow.flf
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/chsh" -o /etc/pam.d/chsh
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/.draw" -o $HOME/.draw
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/.banner.sh" -o $HOME/.banner.sh
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/rename.sh" -o /usr/bin/theader-rename
    sudo_if_possible curl -fsSL "https://raw.githubusercontent.com/ManiacBoy777/T-Header/fish-master/uninstall.sh" -o /usr/bin/theader-uninstall
    chmod +x /usr/bin/theader-rename
    chmod +x /usr/bin/theader-uninstall

    #name prompt
    clear
    name_prompt
    clear

    # Add lines to config.fish
    add_fish_lines
    # Add lines to fish_prompt
    add_custom_prompt_lines
    chsh -s /bin/usr/fish
    echo Complete!
    echo
    echo "Please wait for new terminal session to start"
    echo
    echo "The first time might take a second"
    exec fish

else
echo ""
    echo "accepted arguments: --termux"
    echo "Usage: installs the original script by remo773 made for termux instead of the desktop version"
    echo ""
    exit 1
fi