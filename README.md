# T-Header: Robust Terminal Customization (Zsh Version)

T-Header is a powerful and easy-to-use terminal customization script for the Zsh shell. It provides a beautiful custom banner, a clean multi-line prompt, and essential plugins to enhance your terminal experience on Linux.

## Features

- [x] **Robust Standalone Installer**: No need to clone the repo; just run the single-line command.
- [x] **Zsh Optimization**: Powered by Oh My Zsh and popular plugins like `zsh-autosuggestions` and `fzf-tab`.
- [x] **Safe Uninstaller**: Only removes components it installed, protecting your other Zsh configurations.
- [x] **Custom Banner**: A high-performance banner with your name using `figlet` and `lolcat`.
- [x] **Enhanced Prompt**: A clean, multi-line prompt with your custom name and hostname.
- [x] **Safety First**: Includes input validation and variable sanitization.

## Installation

To install the robust version of T-Header on your Linux desktop:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/zsh-master/install.sh)"
```

### For Termux Users

To install the original version optimized for Termux:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ManiacBoy777/T-Header/zsh-master/install.sh)" -- --termux
```

## Usage

- **Change Name**: Run `theader-rename` to update your custom name.
- **Uninstall**: Run `theader-uninstall` to safely remove the customization.
- **Aliases**:
  - `ls`, `l`, `la`, `ll`: Enhanced directory listing (uses `exa` if available).
  - `cp`, `mv`, `rm`: Safe mode with confirmation prompts.
  - `cd`: Powered by `zoxide` (if installed).

## Contributing

Feel free to fork this project and submit pull requests for any improvements or new features!

## Credits

Original script by [remo773](https://github.com/remo7777/T-Header). Refactored and optimized for robustness.
