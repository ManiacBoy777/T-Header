# T-Header: Robust Terminal Customization

T-Header is a powerful and easy-to-use terminal customization script for the Fish shell. It provides a beautiful custom banner, a clean prompt, and essential plugins to enhance your terminal experience on Linux.

## Features

- [x] **Robust Installer**: Now with full error handling and modular script organization.
- [x] **Modular Fish Config**: Uses `conf.d/` for cleaner management of aliases and environment variables.
- [x] **Safe Uninstaller**: Only removes components it installed, protecting your other configurations.
- [x] **Custom Banner**: A high-performance banner with your name using `figlet` and `lolcat`.
- [x] **Enhanced Prompt**: A clean, multi-line PS1 with your custom name and hostname.
- [x] **Essential Plugins**: Automatically installs `Oh My Fish`, `Fisher`, `fzf.fish`, `zoxide`, and more.
- [x] **Terminal Widgets**: Integrates `terminal-widgets` for a more interactive startup.
- [x] **Safety First**: Includes input validation and variable sanitization.

## Installation

To install the robust version of T-Header on your Linux desktop:

```bash
git clone https://github.com/ManiacBoy777/T-Header.git
cd T-Header
chmod +x install.sh
./install.sh
```

### For Termux Users

To install the original version optimized for Termux:

```bash
./install.sh --termux
```

## Usage

- **Change Name**: Run `theader-rename` to update your custom name.
- **Uninstall**: Run `theader-uninstall` to safely remove the customization.
- **Aliases**:
  - `ls`, `l`, `la`, `ll`: Enhanced directory listing (uses `exa` if available).
  - `cp`, `mv`, `rm`: Safe mode with confirmation prompts.
  - `cd`: Powered by `zoxide` for smart directory jumping.

## Contributing

Feel free to fork this project and submit pull requests for any improvements or new features!

## Credits

Original script by [remo773](https://github.com/remo7777/T-Header). Refactored and optimized for robustness.
