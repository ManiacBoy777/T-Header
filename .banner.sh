#!/usr/bin/bash
# T-Header: Enhanced Banner Script
# Optimized for performance and robustness

# Get terminal columns and user name
COLS=${1:-$(tput cols)}
TNAME=${2:-"User"}

# Safety checks for dimensions
if [ "$COLS" -lt 20 ]; then COLS=20; fi

# Create the border strings
VAR2=$(printf '─%.0s' $(seq 1 $((COLS - 2))))
VAR3=$(printf ' %.0s' $(seq 1 $((COLS - 2))))
VAR4=$((COLS - 20))
if [ "$VAR4" -lt 0 ]; then VAR4=0; fi

# Define helper functions for the draw script
cat > ~/.draw.sh << EOF
#!/usr/bin/bash
PUT(){ echo -en "\033[\${1};\${2}H";}
DRAW(){ echo -en "\033%";echo -en "\033(0";}
WRITE(){ echo -en "\033(B";}
HIDECURSOR(){ echo -en "\033[?25l";}
NORM(){ echo -en "\033[?12l\033[?25h";}

HIDECURSOR
clear
echo -e "\033[35;1m"

# Draw the main frame
echo "┌${VAR2}┐"
for ((i=1; i<=8; i++)); do
    echo "│${VAR3}│"
done
echo "└${VAR2}┘"

# Position and draw the centered name using figlet
PUT 4 0
if command -v figlet >/dev/null; then
    figlet -c -f ASCII-Shadow -w ${COLS} "${TNAME}" | lolcat -t 2>/dev/null || figlet -c -w ${COLS} "${TNAME}"
else
    echo -e "\033[32m   ${TNAME}   \033[0m"
fi

# Draw vertical bars
PUT 3 0
echo -e "\033[35;1m"
for ((i=1; i<=7; i++)); do
    echo "│"
done

# Draw version/boot info
PUT 10 ${VAR4}
if command -v lolcat >/dev/null; then
    echo -e "\e[32mBoot Script \e[33m3.0 (Robust)\e[0m" | lolcat -t -F 0.25 2>/dev/null
else
    echo -e "\e[32mBoot Script \e[33m3.0 (Robust)\e[0m"
fi

PUT 12 0
echo
NORM
EOF

# Execute the generated draw script
bash ~/.draw.sh
